package com.clevertap.clevertap_signedcall_flutter.plugin

import android.annotation.SuppressLint
import android.content.Context
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.exception.CallException
import com.clevertap.android.signedcall.exception.InitException
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration
import com.clevertap.android.signedcall.interfaces.OutgoingCallResponse
import com.clevertap.android.signedcall.interfaces.SignedCallInitResponse
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_ALLOW_PERSIST_SOCKET_CONNECTION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_CONTEXT
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_OPTIONS
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_PROPERTIES
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_INIT_PROPERTIES
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_LOG_LEVEL
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_MISSED_CALL_ACTIONS
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_OVERRIDE_DEFAULT_BRANDING
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_PROMPT_PUSH_PRIMER
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_PROMPT_RECEIVER_READ_PHONE_STATE_PERMISSION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_RECEIVER_CUID
import com.clevertap.clevertap_signedcall_flutter.Constants.TAG
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.CALL
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.DISCONNECT_SIGNALLING_SOCKET
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.HANG_UP_CALL
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.INIT
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.LOGGING
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.LOGOUT
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_INITIALIZE
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.TRACK_SDK_VERSION
import com.clevertap.clevertap_signedcall_flutter.extensions.toSignedCallLogLevel
import com.clevertap.clevertap_signedcall_flutter.handlers.CallEventStreamHandler
import com.clevertap.clevertap_signedcall_flutter.handlers.MissedCallActionClickHandler
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseBrandingFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseExceptionToMapObject
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseInitOptionsFromInitProperties
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseMissedCallActionsFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parsePushPrimerConfigFromInitOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

@SuppressLint("RestrictedApi")
class SignedCallFlutterMethodCallHandler(
    private val context: Context?, private val methodChannel: MethodChannel?
) : ISignedCallMethodCallHandler, MethodChannel.MethodCallHandler {

    private var cleverTapAPI: CleverTapAPI? = null

    init {
        Utils.log(message = "CallStateListener is called0")

        cleverTapAPI = CleverTapAPI.getDefaultInstance(context)

        if (!SignedCallUtils.isAppInBackground()) {
            SignedCallAPI.getInstance().registerVoIPCallStatusListener { callStatusDetails ->
                Utils.log(message = "CallStateListener is called in foreground: $callStatusDetails")
                streamCallEvent(callStatusDetails)
                /*if (SignedCallUtils.isAppInBackground()) {
                    Utils.log(message = "CallStateListener is called in background: $callStatusDetails")
                    CleverTapBackgroundIsolateRunner.startBackgroundIsolate(context, callStatusDetails)
                } else {
                    Utils.log(message = "CallStateListener is called in foreground: $callStatusDetails")
                    streamCallEvent(callStatusDetails)
                }*/
            }
        }
    }

    companion object {
        const val ERROR_CLEVERTAP_INSTANCE_NOT_INITIALIZED = "CleverTap Instance is not initialized"
    }

    //Called when a method-call is invoked from flutterPlugin
    override fun onMethodCall(call: MethodCall, result: Result) {
        Utils.log(message = "Inside onMethodCall: \n invoked method - \'${call.method}\' \n method-arguments - ${call.arguments} ")
        when (call.method) {
            TRACK_SDK_VERSION -> {
                trackSdkVersion(call, result)
            }

            LOGGING -> {
                setDebugLevel(call, result)
            }

            INIT -> {
                initSignedCallSdk(call, result)
            }

            CALL -> {
                initiateVoipCall(call, result)
            }

            DISCONNECT_SIGNALLING_SOCKET -> {
                disconnectSignallingSocket(result)
            }

            LOGOUT -> {
                logout(result)
            }

            HANG_UP_CALL -> {
                hangUpCall(result)
            }
            REGISTER_ON_CALL_EVENT_IN_KILLED_STATE_HANDLER -> {
                val dispatcherHandle = Utils.parseLong(call.argument(DISPATCHER_HANDLE))
                val callbackHandle = Utils.parseLong(call.argument(CALLBACK_HANDLE))
                if (dispatcherHandle != null && callbackHandle != null) {
                    IsolateHandlePreferences.saveCallbackKeys(context, dispatcherHandle, callbackHandle)
                }

            }
            else -> result.notImplemented()
        }
    }

    @SuppressLint("RestrictedApi")
    override fun trackSdkVersion(call: MethodCall, result: Result) {
        val sdkName = call.argument<String>("sdkName")
        val sdkVersion = call.argument<Int>("sdkVersion")!!
        cleverTapAPI?.let {
            cleverTapAPI!!.setCustomSdkVersion(sdkName, sdkVersion)
            result.success(null)
        } ?: run {
            result.error(TAG, ERROR_CLEVERTAP_INSTANCE_NOT_INITIALIZED, null)
        }
    }

    override fun setDebugLevel(call: MethodCall, result: Result) {
        val debugLevel = call.argument<Int>(KEY_LOG_LEVEL)
        debugLevel?.let { SignedCallAPI.setDebugLevel(debugLevel.toSignedCallLogLevel()) }
        result.success(null)
    }

    //Retrieves the init-properties from call-arguments  Initializes the Signed Call Android SDK
    override fun initSignedCallSdk(call: MethodCall, result: Result) {
        try {
            val initProperties = call.argument<Map<String, Any>>(KEY_INIT_PROPERTIES)

            val initOptions = initProperties?.let { parseInitOptionsFromInitProperties(it) }

            val allowPersistSocketConnection =
                initProperties?.getOrElse(KEY_ALLOW_PERSIST_SOCKET_CONNECTION) { false } as Boolean

            val promptReceiverReadPhoneStatePermission =
                initProperties.getOrElse(KEY_PROMPT_RECEIVER_READ_PHONE_STATE_PERMISSION) { false } as Boolean

            val callScreenBranding = initProperties[KEY_OVERRIDE_DEFAULT_BRANDING]?.let {
                parseBrandingFromInitOptions(it as Map<*, *>)
            }

            val pushPrimerConfig: JSONObject? = initProperties[KEY_PROMPT_PUSH_PRIMER]?.let {
                parsePushPrimerConfigFromInitOptions(it as Map<*, *>)
            }

            val missedCallActionsList = initProperties[KEY_MISSED_CALL_ACTIONS]?.let {
                parseMissedCallActionsFromInitOptions(it as Map<*, *>)
            }

            val missedCallActionClickHandlerPath =
                MissedCallActionClickHandler::class.java.canonicalName

            val initConfiguration =
                SignedCallInitConfiguration.Builder(initOptions, allowPersistSocketConnection)
                    .promptPushPrimer(pushPrimerConfig)
                    .promptReceiverReadPhoneStatePermission(promptReceiverReadPhoneStatePermission)
                    .overrideDefaultBranding(callScreenBranding).setMissedCallActions(
                        missedCallActionsList, missedCallActionClickHandlerPath
                    ).build()

            SignedCallAPI.getInstance()
                .init(context, initConfiguration, cleverTapAPI, object : SignedCallInitResponse {
                    override fun onSuccess() {
                        methodChannel?.invokeMethod(ON_SIGNED_CALL_DID_INITIALIZE, null)
                    }

                    override fun onFailure(initException: InitException) {
                        methodChannel?.invokeMethod(
                            ON_SIGNED_CALL_DID_INITIALIZE, parseExceptionToMapObject(initException)
                        )
                    }
                })
            result.success(null)
        } catch (e: Exception) {
            e.printStackTrace()
            val errorMsg =
                "Unable to initialize the Signed Call Flutter Plugin: " + e.localizedMessage
            Utils.log(message = errorMsg)
            result.error(TAG, errorMsg, null)
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

            SignedCallAPI.getInstance().call(context,
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
            result.success(null)
        } catch (e: Exception) {
            e.printStackTrace()
            val errorMsg = "Unable to initiate the VoIP call: " + e.localizedMessage
            Utils.log(message = errorMsg)
            result.error(TAG, errorMsg, null)
        }
    }

    //Disconnects the signalling socket
    override fun disconnectSignallingSocket(result: Result) {
        SignedCallAPI.getInstance().disconnectSignallingSocket(context)
        result.success(null)
    }

    //Logs out the Signed Call SDK session
    override fun logout(result: Result) {
        SignedCallAPI.getInstance().logout(context)
        result.success(null)
    }

    //Ends the active call, if any.
    override fun hangUpCall(result: Result) {
        SignedCallAPI.getInstance().callController?.endCall()
        result.success(null)
    }

    //Sends the real-time changes in the call-state in an observable event-stream
    override fun streamCallEvent(callStatusDetails: SCCallStatusDetails) {
        Utils.log(message = "Streaming $callStatusDetails to event-channel")
        CallEventStreamHandler.eventSink?.success(callStatusDetails.toMap())
    }
}