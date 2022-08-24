package com.example.clevertap_directcall_flutter.plugin

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
import com.example.clevertap_directcall_flutter.util.Constants.KEY_INIT_OPTIONS
import com.example.clevertap_directcall_flutter.util.Constants.KEY_INIT_PROPERTIES
import com.example.clevertap_directcall_flutter.util.Constants.KEY_RECEIVER_CUID
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.CALL
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.INIT
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.ON_DIRECT_CALL_DID_INITIALIZE
import com.example.clevertap_directcall_flutter.util.DCMethodCallNames.ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE
import com.example.clevertap_directcall_flutter.util.Utils.parseExceptionToMap
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** ClevertapDirectcallFlutterPlugin */
class DirectcallFlutterAndroidPlugin :
    BaseDirectCallFlutterAndroidPlugin, FlutterPluginLifecycleHandler(),
    MethodChannel.MethodCallHandler, EventChannel.StreamHandler {

    private var cleverTapAPI: CleverTapAPI? = null

    init {
        super.setupFlutterPlugin(methodCallHandler = this, eventStreamHandler = this) {
            cleverTapAPI = CleverTapAPI.getDefaultInstance(context)
        }
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

    //Retrieves the init-properties from call-arguments  Initializes the Direct Call Android SDK
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
                            methodChannel.invokeMethod(ON_DIRECT_CALL_DID_INITIALIZE, null)
                        }

                        override fun onFailure(initException: InitException) {
                            methodChannel.invokeMethod(
                                ON_DIRECT_CALL_DID_INITIALIZE, parseExceptionToMap(initException)
                            )
                        }
                    })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    //Retrieves the call-properties from call-arguments and initiates a VoIP call
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
                        streamCallEvent(callStatus)
                    }

                    override fun onSuccess() {
                        methodChannel.invokeMethod(ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE, null)
                    }

                    override fun onFailure(callException: CallException) {
                        methodChannel.invokeMethod(
                            ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE,
                            parseExceptionToMap(callException)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink?) {
        this.eventSink = eventSink;
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    private fun streamCallEvent(event: VoIPCallStatus) {
        eventSink?.let { sink ->
            val eventDescription = when (event) {
                VoIPCallStatus.CALL_CANCELLED -> "Cancelled"
                VoIPCallStatus.CALL_DECLINED -> "Declined"
                VoIPCallStatus.CALL_MISSED -> "Missed"
                VoIPCallStatus.CALL_ANSWERED -> "Answered"
                VoIPCallStatus.CALL_IN_PROGRESS -> "CallInProgress"
                VoIPCallStatus.CALL_OVER -> "Ended"
                VoIPCallStatus.CALLEE_BUSY_ON_ANOTHER_CALL -> "ReceiverBusyOnAnotherCall"
            }
            sink.success(eventDescription)
        }
    }
}
