package com.example.clevertap_signedcall_flutter.plugin

import android.content.Context
import androidx.annotation.NonNull
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.exception.CallException
import com.clevertap.android.signedcall.exception.InitException
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration
import com.clevertap.android.signedcall.interfaces.OutgoingCallResponse
import com.clevertap.android.signedcall.interfaces.SignedCallInitResponse
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import com.example.clevertap_signedcall_flutter.Constants.KEY_ALLOW_PERSIST_SOCKET_CONNECTION
import com.example.clevertap_signedcall_flutter.Constants.KEY_CALL_CONTEXT
import com.example.clevertap_signedcall_flutter.Constants.KEY_CALL_OPTIONS
import com.example.clevertap_signedcall_flutter.Constants.KEY_CALL_PROPERTIES
import com.example.clevertap_signedcall_flutter.Constants.KEY_DEBUG_LEVEL
import com.example.clevertap_signedcall_flutter.Constants.KEY_ENABLE_READ_PHONE_STATE
import com.example.clevertap_signedcall_flutter.Constants.KEY_INIT_PROPERTIES
import com.example.clevertap_signedcall_flutter.Constants.KEY_MISSED_CALL_ACTIONS
import com.example.clevertap_signedcall_flutter.Constants.KEY_OVERRIDE_DEFAULT_BRANDING
import com.example.clevertap_signedcall_flutter.Constants.KEY_RECEIVER_CUID
import com.example.clevertap_signedcall_flutter.SCMethodCall.CALL
import com.example.clevertap_signedcall_flutter.SCMethodCall.HANG_UP_CALL
import com.example.clevertap_signedcall_flutter.SCMethodCall.INIT
import com.example.clevertap_signedcall_flutter.SCMethodCall.IS_ENABLED
import com.example.clevertap_signedcall_flutter.SCMethodCall.LOGGING
import com.example.clevertap_signedcall_flutter.SCMethodCall.LOGOUT
import com.example.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_INITIALIZE
import com.example.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE
import com.example.clevertap_signedcall_flutter.extensions.toMap
import com.example.clevertap_signedcall_flutter.extensions.toSignedCallLogLevel
import com.example.clevertap_signedcall_flutter.handlers.CallEventStreamHandler
import com.example.clevertap_signedcall_flutter.handlers.MissedCallActionClickHandler
import com.example.clevertap_signedcall_flutter.handlers.MissedCallActionEventStreamHandler
import com.example.clevertap_signedcall_flutter.util.Utils.parseBrandingFromInitOptions
import com.example.clevertap_signedcall_flutter.util.Utils.parseExceptionToMapObject
import com.example.clevertap_signedcall_flutter.util.Utils.parseInitOptionsFromInitProperties
import com.example.clevertap_signedcall_flutter.util.Utils.parseMissedCallActionsFromInitOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

class SignedCallFlutterMethodCallHandler(
    private val context: Context?,
    private val methodChannel: MethodChannel?
) :
    ISignedCallTask,
    MethodChannel.MethodCallHandler {

    private var cleverTapAPI: CleverTapAPI? = null

    init {
        cleverTapAPI = CleverTapAPI.getDefaultInstance(context)
    }

    //Called when a method-call is invoked from flutterPlugin
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            LOGGING -> {
                setDebugLevel(call)
                result.success(null)
            }
            INIT -> {
                initSignedCallSdk(call)
                result.success(null)
            }
            CALL -> {
                initiateVoipCall(call)
                result.success(null)
            }
            LOGOUT -> {
                logout()
                result.success(null)
            }
            IS_ENABLED -> {
                result.success(isSignedCallSdkEnabled())
            }
            HANG_UP_CALL -> {
                hangUpCall()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun setDebugLevel(call: MethodCall) {
        val debugLevel = call.argument<Int>(KEY_DEBUG_LEVEL)
        debugLevel?.let { SignedCallAPI.setDebugLevel(debugLevel.toSignedCallLogLevel()) }
    }

    //Retrieves the init-properties from call-arguments  Initializes the Signed Call Android SDK
    override fun initSignedCallSdk(call: MethodCall) {
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

            val initConfiguration =
                SignedCallInitConfiguration.Builder(initOptions, allowPersistSocketConnection)
                    .promptReceiverReadPhoneStatePermission(enableReadPhoneState)
                    .overrideDefaultBranding(callScreenBranding)
                    .setMissedCallActions(
                        missedCallActionsList,
                        missedCallActionClickHandlerPath
                    )
                    .build()

            SignedCallAPI.getInstance().init(
                context,
                initConfiguration,
                cleverTapAPI,
                object : SignedCallInitResponse {
                    override fun onSuccess() {
                        methodChannel?.invokeMethod(ON_SIGNED_CALL_DID_INITIALIZE, null)
                    }

                    override fun onFailure(initException: InitException) {
                        methodChannel?.invokeMethod(
                            ON_SIGNED_CALL_DID_INITIALIZE, parseExceptionToMapObject(initException)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    //Retrieves the call-properties from call-arguments and initiates a VoIP call
    override fun initiateVoipCall(call: MethodCall) {
        try {
            val callProperties = call.argument<Map<String, Any>>(KEY_CALL_PROPERTIES)
            val receiverCuid = callProperties?.let { it[KEY_RECEIVER_CUID] as String }
            val callContext = callProperties?.let { it[KEY_CALL_CONTEXT] as String }
            val callOptions = callProperties?.let {
                if (it[KEY_CALL_OPTIONS] != null) JSONObject(it[KEY_CALL_OPTIONS] as Map<*, *>) else null
            }

            SignedCallAPI.getInstance().call(
                context,
                receiverCuid,
                callContext,
                callOptions,
                object : OutgoingCallResponse {
                    override fun callStatus(callStatus: VoIPCallStatus) {
                        streamCallEvent(callStatus)
                    }

                    override fun onSuccess() {
                        methodChannel?.invokeMethod(ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE, null)
                    }

                    override fun onFailure(callException: CallException) {
                        methodChannel?.invokeMethod(
                            ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE,
                            parseExceptionToMapObject(callException)
                        )
                    }
                })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add here error reporting
        }
    }

    //Logs out the Signed Call SDK session
    override fun logout() {
        SignedCallAPI.getInstance().logout(context)
    }

    //Checks and returns the state of Signed Call SDK services(i.e. call initiation or reception) are enabled or not
    override fun isSignedCallSdkEnabled(): Boolean {
        return /*SignedCallAPI.getInstance().isEnabled*/ true
    }

    //Ends the active call, if any.
    override fun hangUpCall() {
        SignedCallAPI.getInstance().callController?.endCall()
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
