package com.clevertap.clevertap_signedcall_flutter.isolate

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.clevertap.clevertap_signedcall_flutter.Constants
import com.clevertap.clevertap_signedcall_flutter.SCAppContextHolder
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_CALL_EVENT
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_FCM_NOTIFICATION_CANCEL_CTA_CLICKED
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_FCM_NOTIFICATION_CLICKED
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED
import com.clevertap.clevertap_signedcall_flutter.util.Utils.log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterShellArgs
import io.flutter.embedding.engine.dart.DartExecutor.DartCallback
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.view.FlutterCallbackInformation
import java.util.concurrent.ConcurrentLinkedQueue
import java.util.concurrent.atomic.AtomicBoolean

/**
 * A background executor which handles initializing a background isolate running a callback dispatcher,
 * used to invoke Dart callbacks in background/killed state.
 */
class SCBackgroundIsolateExecutor : MethodCallHandler {

    companion object {
        private const val TAG = "SCBackgroundIsolateExecutor"
    }

    private val isCallbackDispatcherReady = AtomicBoolean(false)
    private val isProcessingPayload = AtomicBoolean(false)
    private val isInitializing = AtomicBoolean(false)
    private val isInitialized = AtomicBoolean(false)
    private var backgroundFlutterEngine: FlutterEngine? = null
    private lateinit var backgroundChannel: MethodChannel

    private val payloadQueue = ConcurrentLinkedQueue<Pair<String, Map<String, Any>>>()

    /**
     * Starts running a background Dart isolate within a new [FlutterEngine] using a previously
     * used entrypoint.
     */
    fun startBackgroundIsolate(context: Context, methodName: String, payloadMap: Map<String, Any>) {
        payloadQueue.offer(Pair(methodName, payloadMap))
        if (isInitialized.get()) {
            processNextPayload(context)
        } else if (isInitializing.compareAndSet(false, true)) {
            initializeBackgroundIsolate(context)
        }
    }

    /**
     * Initializes the background Dart isolate.
     */
    private fun initializeBackgroundIsolate(context: Context) {
        if (isCallbackDispatcherReady.get()) {
            processNextPayload(context)
            return
        }
        val callbackHandle = getPluginCallbackHandle(context)
        if (callbackHandle != 0L) {
            startBackgroundIsolate(context, callbackHandle, null)
        }
    }

    /**
     * Starts running a background Dart isolate within a new [FlutterEngine] using a previously
     * used entrypoint.
     *
     * Preconditions:
     * The given [callbackHandle] must correspond to a registered Dart callback. If the
     * handle does not resolve to a Dart callback then this method does nothing.
     */
    private fun startBackgroundIsolate(context: Context, callbackHandle: Long, shellArgs: FlutterShellArgs?) {
        if (backgroundFlutterEngine != null) {
            Log.e(TAG, "Background isolate already started.")
            return
        }

        val loader = FlutterLoader()
        val mainHandler = Handler(Looper.getMainLooper())
        val myRunnable = Runnable {
            // startInitialization() must be called on the main thread.
            loader.startInitialization(context)

            loader.ensureInitializationCompleteAsync(context, null, mainHandler) {
                val appBundlePath = loader.findAppBundlePath()
                val assets = context.assets
                if (isNotRunning()) {
                    if (shellArgs != null) {
                        Log.i(
                            TAG, "Creating background FlutterEngine instance, with args: ${
                                shellArgs.toArray().contentToString()
                            }"
                        )
                        backgroundFlutterEngine = FlutterEngine(context, shellArgs.toArray())
                    } else {
                        Log.i(TAG, "Creating background FlutterEngine instance.")
                        backgroundFlutterEngine = FlutterEngine(context)
                    }
                    // We need to create an instance of `FlutterEngine` before looking up the
                    // callback. If we don't, the callback cache won't be initialized and the
                    // lookup will fail.
                    val flutterCallback = FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
                    val executor = backgroundFlutterEngine!!.dartExecutor
                    initializeMethodChannel(executor)
                    val dartCallback = DartCallback(assets, appBundlePath, flutterCallback)
                    executor.executeDartCallback(dartCallback)
                }
            }
        }
        mainHandler.post(myRunnable)
    }

    private fun initializeMethodChannel(isolate: BinaryMessenger) {
        backgroundChannel = MethodChannel(isolate, "${Constants.CHANNEL_NAME}/background_isolate_channel")
        backgroundChannel.setMethodCallHandler(this)
    }

    /**
     * Executes the desired Dart callback in a background Dart isolate.
     *
     * The given [methodName] should represent the name of the Dart method to be called.
     * The [payloadMap] contains the payload data to be passed to the Dart method.
     *
     * @param context The application context.
     * @param methodName The name of the Dart method to be called.
     * @param payloadMap The payload map to be passed to the Dart method.
     */
    private fun executeDartCallbackInBackgroundIsolate(
        context: Context, methodName: String?, payloadMap: Map<String, Any>?
    ) {
        if (backgroundFlutterEngine == null) {
            log(TAG, "A background message could not be handled in Dart as no background isolate has been created")
            isProcessingPayload.set(false)
            return
        }

        try {
            getUserCallbackHandle(context, methodName!!).let { userCallbackHandle ->
                log(TAG, "Invoking Dart callback for method: $methodName")
                backgroundChannel.invokeMethod(
                    methodName, mapOf(
                        "userCallbackHandle" to userCallbackHandle, "payload" to (payloadMap ?: emptyMap())
                    )
                )
                isProcessingPayload.set(false)
                processNextPayload(context)
            }
        } catch (e: Exception) {
            log(TAG, "Failed to invoke the '$methodName' dart callback. ${e.localizedMessage}")
            isProcessingPayload.set(false)
            processNextPayload(context)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val method = call.method
        try {
            when (method) {
                "SCBackgroundCallbackDispatcher#initialized" -> {
                    onInitialized()
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("error", "SCBackgroundIsolateExecutor's error: ${e.message}", null)
        }
    }

    /**
     * Called once the Dart background isolate(i.e. callbackDispatcher) has finished initializing.
     */
    private fun onInitialized() {
        Log.i(TAG, "BackgroundCallbackDispatcher is initialized to receive a user's DartCallback request!")
        isCallbackDispatcherReady.set(true)
        isInitialized.set(true)
        isInitializing.set(false)
        processNextPayload(SCAppContextHolder.getApplicationContext()!!)
    }

    /**
     * Processes the next payload in the queue.
     */
    private fun processNextPayload(context: Context) {
        if (isProcessingPayload.get() || payloadQueue.isEmpty()) return

        val payload = payloadQueue.poll()
        if (payload != null) {
            val (methodName, payloadMap) = payload
            isProcessingPayload.set(true)
            executeDartCallbackInBackgroundIsolate(context, methodName, payloadMap)
        }
    }

    /**
     * Retrieves the user's registered Dart callback handle for background messaging.
     * Returns `null` if not set.
     *
     * @param context The application context.
     * @param methodName The method name for which the callback handle is requested.
     * @return The callback handle for the specified method, or `null` if not set.
     */
    private fun getUserCallbackHandle(context: Context, methodName: String): Long? {
        val callbackHandleSuffix = when (methodName) {
            BACKGROUND_ISOLATE_CALL_EVENT -> Constants.ISOLATE_SUFFIX_CALL_EVENT_CALLBACK
            BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED -> Constants.ISOLATE_SUFFIX_MISSED_CALL_ACTION_CLICKED_CALLBACK
            BACKGROUND_ISOLATE_FCM_NOTIFICATION_CLICKED -> Constants.ISOLATE_SUFFIX_FCM_NOTIFICATION_CLICKED
            BACKGROUND_ISOLATE_FCM_NOTIFICATION_CANCEL_CTA_CLICKED -> Constants.ISOLATE_SUFFIX_FCM_NOTIFICATION_CANCEL_CTA_CLICKED
            else -> return null
        }
        return IsolateHandlePreferences.getUserCallbackHandle(context, callbackHandleSuffix)
    }

    /**
     * Returns true if the Dart background handler(i.e. CallbackDispatcher) is registered for background messaging.
     */
    fun isDartBackgroundHandlerRegistered(context: Context): Boolean {
        return getPluginCallbackHandle(context) != 0L
    }

    /**
     * Returns true when the background isolate is not started to handle background messages.
     */
    private fun isNotRunning(): Boolean {
        return !isCallbackDispatcherReady.get()
    }

    /**
     * Get the registered Dart callback handle for the messaging plugin. Returns 0 if not set.
     */
    private fun getPluginCallbackHandle(context: Context): Long {
        return IsolateHandlePreferences.getCallbackDispatcherHandle(context)
    }
}