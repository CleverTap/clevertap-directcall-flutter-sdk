package com.example.clevertap_directcall_flutter.plugin

import androidx.annotation.NonNull
import com.clevertap.android.directcall.exception.CallException
import com.clevertap.android.directcall.exception.InitException
import com.clevertap.android.directcall.init.DirectCallAPI
import com.clevertap.android.directcall.init.DirectCallInitOptions
import com.clevertap.android.directcall.interfaces.DirectCallInitResponse
import com.clevertap.android.directcall.interfaces.OutgoingCallResponse
import com.clevertap.android.directcall.javaclasses.VoIPCallStatus
import com.clevertap.android.directcall.models.MissedCallNotificationOpenResult
import com.clevertap.android.sdk.CleverTapAPI
import com.example.clevertap_directcall_flutter.Constants.KEY_ALLOW_PERSIST_SOCKET_CONNECTION
import com.example.clevertap_directcall_flutter.Constants.KEY_CALL_CONTEXT
import com.example.clevertap_directcall_flutter.Constants.KEY_CALL_OPTIONS
import com.example.clevertap_directcall_flutter.Constants.KEY_CALL_PROPERTIES
import com.example.clevertap_directcall_flutter.Constants.KEY_ENABLE_READ_PHONE_STATE
import com.example.clevertap_directcall_flutter.Constants.KEY_INIT_PROPERTIES
import com.example.clevertap_directcall_flutter.Constants.KEY_MISSED_CALL_ACTIONS
import com.example.clevertap_directcall_flutter.Constants.KEY_OVERRIDE_DEFAULT_BRANDING
import com.example.clevertap_directcall_flutter.Constants.KEY_RECEIVER_CUID
import com.example.clevertap_directcall_flutter.DCMethodCall.CALL
import com.example.clevertap_directcall_flutter.DCMethodCall.HANG_UP_CALL
import com.example.clevertap_directcall_flutter.DCMethodCall.INIT
import com.example.clevertap_directcall_flutter.DCMethodCall.IS_ENABLED
import com.example.clevertap_directcall_flutter.DCMethodCall.LOGOUT
import com.example.clevertap_directcall_flutter.DCMethodCall.ON_DIRECT_CALL_DID_INITIALIZE
import com.example.clevertap_directcall_flutter.DCMethodCall.ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE
import com.example.clevertap_directcall_flutter.extensions.toMap
import com.example.clevertap_directcall_flutter.handlers.CallEventStreamHandler
import com.example.clevertap_directcall_flutter.handlers.MissedCallActionClickHandler
import com.example.clevertap_directcall_flutter.handlers.MissedCallActionEventStreamHandler
import com.example.clevertap_directcall_flutter.util.Utils.parseBrandingFromInitOptions
import com.example.clevertap_directcall_flutter.util.Utils.parseExceptionToMapObject
import com.example.clevertap_directcall_flutter.util.Utils.parseInitOptionsFromInitProperties
import com.example.clevertap_directcall_flutter.util.Utils.parseMissedCallActionsFromInitOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** ClevertapDirectcallFlutterPlugin */
class DirectcallFlutterAndroidPlugin :
    BaseDirectCallFlutterAndroidPlugin, FlutterPluginLifecycleHandler(),
    MethodChannel.MethodCallHandler {

    private var cleverTapAPI: CleverTapAPI? = null

    init {
        super.setupFlutterPlugin(methodCallHandler = this) {
            cleverTapAPI = CleverTapAPI.getDefaultInstance(context)
            callEventChannel?.setStreamHandler(CallEventStreamHandler)
            missedCallActionClickEventChannel?.setStreamHandler(MissedCallActionEventStreamHandler);
        }
    }

    //Called when a method-call is invoked from flutterPlugin
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
            LOGOUT -> {
                logout()
                result.success(null)
            }
            IS_ENABLED -> {
                result.success(isDirectCallSdkEnabled())
            }
            HANG_UP_CALL -> {
                hangUpCall()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    //Retrieves the init-properties from call-arguments  Initializes the Direct Call Android SDK
    override fun initDirectCallSdk(call: MethodCall, result: Result) {
        try {
            val initProperties = call.argument<Map<String, Any>>(KEY_INIT_PROPERTIES)

            val initOptions = initProperties?.let { parseInitOptionsFromInitProperties(it) }
            val allowPersistSocketConnection =
                initProperties?.getOrElse(KEY_ALLOW_PERSIST_SOCKET_CONNECTION) { false } as Boolean
            val enableReadPhoneState =
                initProperties.getOrElse(KEY_ENABLE_READ_PHONE_STATE) { false } as Boolean
            val callScreenBranding = parseBrandingFromInitOptions(
                initProperties[KEY_OVERRIDE_DEFAULT_BRANDING] as Map<*, *>
            )
            val missedCallActionsList = initProperties[KEY_MISSED_CALL_ACTIONS]?.let {
                parseMissedCallActionsFromInitOptions(it as Map<*, *>)
            }

            val missedCallActionClickHandlerPath =
                MissedCallActionClickHandler::class.java.canonicalName

            val directCallInitBuilder =
                DirectCallInitOptions.Builder(initOptions, allowPersistSocketConnection)
                    .enableReadPhoneState(enableReadPhoneState)
                    .overrideDefaultBranding(callScreenBranding)
                    .setMissedCallReceiverActions(
                        missedCallActionsList,
                        missedCallActionClickHandlerPath
                    )
                    .build()

            DirectCallAPI.getInstance().init(
                context,
                directCallInitBuilder,
                cleverTapAPI,
                object : DirectCallInitResponse {
                    override fun onSuccess() {
                        methodChannel?.invokeMethod(ON_DIRECT_CALL_DID_INITIALIZE, null)
                    }

                    override fun onFailure(initException: InitException) {
                        methodChannel?.invokeMethod(
                            ON_DIRECT_CALL_DID_INITIALIZE, parseExceptionToMapObject(initException)
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
            val receiverCuid = callProperties?.let { it[KEY_RECEIVER_CUID] as String }
            val callContext = callProperties?.let { it[KEY_CALL_CONTEXT] as String }
            val callOptions = callProperties?.let {
                if (it[KEY_CALL_OPTIONS] != null) JSONObject(it[KEY_CALL_OPTIONS] as Map<*, *>) else null
            }

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
                        methodChannel?.invokeMethod(ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE, null)
                    }

                    override fun onFailure(callException: CallException) {
                        methodChannel?.invokeMethod(
                            ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE,
                            parseExceptionToMapObject(callException)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    //Logs out the Direct Call SDK session
    override fun logout() {
        DirectCallAPI.getInstance().logout(context)
    }

    //Checks and returns the state of Direct Call SDK services(i.e. call initiation or reception) are enabled or not
    override fun isDirectCallSdkEnabled(): Boolean {
        return DirectCallAPI.getInstance().isEnabled
    }

    //Ends the active call, if any.
    override fun hangUpCall() {
        DirectCallAPI.getInstance().callController?.endCall()
    }

    //Sends the real-time changes in the call-state in an observable event-stream
    override fun streamCallEvent(event: VoIPCallStatus) {
        CallEventStreamHandler.eventSink?.let { sink ->
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

    //Sends the real-time changes in the call-state in an observable event-stream
    override fun streamMissedCallActionClickResult(result: MissedCallNotificationOpenResult) {
        MissedCallActionEventStreamHandler.eventSink?.success(result.toMap())
    }
}
