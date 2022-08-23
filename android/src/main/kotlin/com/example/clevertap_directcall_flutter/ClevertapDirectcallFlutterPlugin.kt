package com.example.clevertap_directcall_flutter

import android.content.Context
import androidx.annotation.NonNull
import com.clevertap.android.directcall.exception.CallException
import com.clevertap.android.directcall.exception.InitException
import com.clevertap.android.directcall.init.DirectCallAPI
import com.clevertap.android.directcall.init.DirectCallInitOptions
import com.clevertap.android.directcall.interfaces.DirectCallInitResponse
import com.clevertap.android.directcall.interfaces.OutgoingCallResponse
import com.clevertap.android.directcall.javaclasses.VoIPCallStatus
import com.clevertap.android.sdk.CleverTapAPI
import com.example.clevertap_directcall_flutter.util.Constants.KEY_ALLOW_PERSIST_SOCKET_CONNECTION
import com.example.clevertap_directcall_flutter.util.Constants.KEY_CALL_CONTEXT
import com.example.clevertap_directcall_flutter.util.Constants.KEY_CALL_OPTIONS
import com.example.clevertap_directcall_flutter.util.Constants.KEY_CALL_PROPERTIES
import com.example.clevertap_directcall_flutter.util.Constants.KEY_ERROR_CODE
import com.example.clevertap_directcall_flutter.util.Constants.KEY_ERROR_DESCRIPTION
import com.example.clevertap_directcall_flutter.util.Constants.KEY_ERROR_MESSAGE
import com.example.clevertap_directcall_flutter.util.Constants.KEY_INIT_OPTIONS
import com.example.clevertap_directcall_flutter.util.Constants.KEY_INIT_PROPERTIES
import com.example.clevertap_directcall_flutter.util.Constants.KEY_RECEIVER_CUID
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.CALL
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.INIT
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.ON_DIRECT_CALL_DID_INITIALIZE
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject


/** ClevertapDirectcallFlutterPlugin */
class ClevertapDirectcallFlutterPlugin : FlutterPlugin, MethodCallHandler,
    DirectCallAndroidPlatformInterface {
    /// The MethodChannel that will establish the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var cleverTapAPI: CleverTapAPI? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setupPlugin(flutterPluginBinding)
    }

    private fun setupPlugin(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "clevertap_directcall_flutter")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
        cleverTapAPI = CleverTapAPI.getDefaultInstance(context);
    }

    /**
     * Called when a method-call is invoked from flutterPlugin
     */
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            INIT -> {
                initDirectCallSdk(call, result)
                result.success(null)
            }
            CALL -> {
                initiateVoipCall(call, result)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun initDirectCallSdk(call: MethodCall, result: Result) {
        try {
            val initProperties = call.argument<Map<String, Any>>(KEY_INIT_PROPERTIES)

            val initJson = initProperties?.let { JSONObject(it[KEY_INIT_OPTIONS] as String) }
            val allowPersistSocketConnection =
                initProperties?.getOrElse(KEY_ALLOW_PERSIST_SOCKET_CONNECTION) { false } as Boolean

            val directCallInitBuilder =
                DirectCallInitOptions.Builder(initJson, allowPersistSocketConnection)
                    .build()

            DirectCallAPI.getInstance()
                .init(
                    context,
                    directCallInitBuilder,
                    cleverTapAPI,
                    object : DirectCallInitResponse {
                        override fun onSuccess() {
                            channel.invokeMethod(ON_DIRECT_CALL_DID_INITIALIZE, null)
                        }

                        override fun onFailure(initException: InitException) {
                            channel.invokeMethod(
                                ON_DIRECT_CALL_DID_INITIALIZE, getErrorMap(initException)
                            )
                        }
                    })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    override fun initiateVoipCall(call: MethodCall, result: Result) {
        try {
            val callProperties = call.argument<Map<String, Any>>(KEY_CALL_PROPERTIES)
            val callOptions = callProperties?.let { JSONObject(it[KEY_CALL_OPTIONS] as String) }
            val receiverCuid = callProperties?.let { it[KEY_RECEIVER_CUID] as String }
            val callContext = callProperties?.let { it[KEY_CALL_CONTEXT] as String }

            DirectCallAPI.getInstance().call(
                context,
                receiverCuid,
                callContext,
                callOptions,
                object : OutgoingCallResponse {
                    override fun callStatus(callStatus: VoIPCallStatus) {
                        //TODO : report call status via Flutter-Stream
                    }

                    override fun onSuccess() {
                        channel.invokeMethod(ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE, null)
                    }

                    override fun onFailure(callException: CallException) {
                        channel.invokeMethod(
                            ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE,
                            getErrorMap(callException)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    private fun getErrorMap(exception: Any): HashMap<String, Any> {
        val error = if (exception is InitException) exception else exception as CallException
        val errorMap = HashMap<String, Any>()
        errorMap[KEY_ERROR_CODE] = error.errorCode
        errorMap[KEY_ERROR_MESSAGE] = error.message!!
        errorMap[KEY_ERROR_DESCRIPTION] = error.explanation
        return errorMap
    }
}
