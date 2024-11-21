package com.clevertap.clevertap_signedcall_flutter.plugin

import android.annotation.SuppressLint
import android.content.Context
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.signedcall.exception.CallException
import com.clevertap.android.signedcall.exception.InitException
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration.FCMProcessingMode
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration.SCSwipeOffBehaviour
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration.SCSwipeOffBehaviour.END_CALL
import com.clevertap.android.signedcall.init.p2p.FCMProcessingNotification
import com.clevertap.android.signedcall.interfaces.OutgoingCallResponse
import com.clevertap.android.signedcall.interfaces.SignedCallInitResponse
import com.clevertap.android.signedcall.utils.SignedCallUtils
import com.clevertap.clevertap_signedcall_flutter.Constants
import com.clevertap.clevertap_signedcall_flutter.Constants.CALLBACK_HANDLE
import com.clevertap.clevertap_signedcall_flutter.Constants.DISPATCHER_HANDLE
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_ALLOW_PERSIST_SOCKET_CONNECTION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_CONTEXT
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_OPTIONS
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_PROPERTIES
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_FCM_NOTIFICATION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_FCM_PROCESSING_MODE
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_SCREEN_ON_SIGNALLING
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_INIT_PROPERTIES
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_LOG_LEVEL
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_MISSED_CALL_ACTIONS
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_NETWORK_CHECK_BEFORE_OUTGOING_CALL_SCREEN
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_NOTIFICATION_PERMISSION_REQUIRED
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_OVERRIDE_DEFAULT_BRANDING
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_PROMPT_PUSH_PRIMER
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_PROMPT_RECEIVER_READ_PHONE_STATE_PERMISSION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_RECEIVER_CUID
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_SWIPE_OFF_BEHAVIOUR_IN_FOREGROUND_SERVICE
import com.clevertap.clevertap_signedcall_flutter.Constants.TAG
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.CALL
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.DISCONNECT_SIGNALLING_SOCKET
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.GET_BACK_TO_CALL
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.GET_CALL_STATE
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.HANG_UP_CALL
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.INIT
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.LOGGING
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.LOGOUT
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_INITIALIZE
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.REGISTER_BACKGROUND_CALL_EVENT_HANDLER
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.REGISTER_BACKGROUND_MISSED_CALL_ACTION_CLICKED_HANDLER
import com.clevertap.clevertap_signedcall_flutter.SCMethodCall.TRACK_SDK_VERSION
import com.clevertap.clevertap_signedcall_flutter.extensions.convertKeysToSnakeCase
import com.clevertap.clevertap_signedcall_flutter.extensions.formattedCallState
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.extensions.toSignedCallLogLevel
import com.clevertap.clevertap_signedcall_flutter.handlers.CallEventStreamHandler
import com.clevertap.clevertap_signedcall_flutter.handlers.MissedCallActionEventStreamHandler
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseBrandingFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseExceptionToMapObject
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseFCMProcessingModeFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseFCMProcessingNotificationFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseInitOptionsFromInitProperties
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseMissedCallActionsFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parsePushPrimerConfigFromInitOptions
import com.clevertap.clevertap_signedcall_flutter.util.Utils.parseSwipeOffBehaviourFromInitOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

@SuppressLint("RestrictedApi")
class SignedCallFlutterMethodCallHandler(
    private val context: Context?, private val methodChannel: MethodChannel?
) : ISignedCallMethodCallHandler, MethodChannel.MethodCallHandler {

    private var cleverTapAPI: CleverTapAPI? = null

    private lateinit var outgoingCallResponse: OutgoingCallResponse

    init {
        cleverTapAPI = CleverTapAPI.getDefaultInstance(context)
        registerListeners()
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

            GET_BACK_TO_CALL -> {
                getBackToCall(result)
            }

            GET_CALL_STATE -> {
                getCallState(result)
            }

            LOGOUT -> {
                logout(result)
            }

            HANG_UP_CALL -> {
                hangUpCall(result)
            }

            REGISTER_BACKGROUND_CALL_EVENT_HANDLER,
            REGISTER_BACKGROUND_MISSED_CALL_ACTION_CLICKED_HANDLER -> {
                handleBackgroundEventHandler(call, result)
            }

            else -> result.notImplemented()
        }
    }

    private fun registerListeners() {
        if (!SignedCallUtils.isAppInBackground()) {
            SignedCallAPI.getInstance().registerVoIPCallStatusListener { callStatusDetails ->
                streamCallEvent(callStatusDetails.toMap())
            }
            SignedCallAPI.getInstance().setMissedCallNotificationOpenedHandler { _, result ->
                streamMissedCallCtaClick(result.toMap())
            }
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

            val notificationPermissionRequired =
                initProperties.getOrElse(KEY_NOTIFICATION_PERMISSION_REQUIRED) { true } as Boolean

            val swipeOffBehaviour: SCSwipeOffBehaviour = initProperties[KEY_SWIPE_OFF_BEHAVIOUR_IN_FOREGROUND_SERVICE]?.let {
                parseSwipeOffBehaviourFromInitOptions(it as String)
            } ?: END_CALL

            val fcmProcessingMode: FCMProcessingMode = initProperties[KEY_FCM_PROCESSING_MODE]?.let {
                parseFCMProcessingModeFromInitOptions(it as String)
            } ?: FCMProcessingMode.FOREGROUND

            val fcmProcessingNotification: FCMProcessingNotification? = initProperties[KEY_FCM_NOTIFICATION]?.let {
                if (context != null)
                    parseFCMProcessingNotificationFromInitOptions(it as Map<*, *>, context)
                else null
            }

            val callScreenOnSignalling =
                initProperties.getOrElse(KEY_CALL_SCREEN_ON_SIGNALLING) { false } as Boolean

            val networkCheckBeforeOutgoingCallScreen =
                initProperties.getOrElse(KEY_NETWORK_CHECK_BEFORE_OUTGOING_CALL_SCREEN) { false } as Boolean

            val initConfiguration =
                SignedCallInitConfiguration.Builder(initOptions, allowPersistSocketConnection)
                    .promptPushPrimer(pushPrimerConfig)
                    .promptReceiverReadPhoneStatePermission(promptReceiverReadPhoneStatePermission)
                    .setNotificationPermissionRequired(notificationPermissionRequired)
                    .overrideDefaultBranding(callScreenBranding)
                    .setMissedCallActions(missedCallActionsList)
                    .setSwipeOffBehaviourInForegroundService(swipeOffBehaviour)
                    .setFCMProcessingMode(fcmProcessingMode, fcmProcessingNotification)
                    .callScreenOnSignalling(callScreenOnSignalling)
                    .networkCheckBeforeOutgoingCallScreen(networkCheckBeforeOutgoingCallScreen)
                    .build()

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
            val callOptions = callProperties?.get(KEY_CALL_OPTIONS)?.let { options ->
                if (options is Map<*, *>) {
                    val callOptionsMap = options as Map<String, Any>
                    JSONObject(callOptionsMap.convertKeysToSnakeCase())
                } else {
                    null
                }
            }

            outgoingCallResponse = object : OutgoingCallResponse {
                override fun onSuccess() {
                    methodChannel?.invokeMethod(ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE, null)
                }

                override fun onFailure(callException: CallException) {
                    methodChannel?.invokeMethod(
                        ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE,
                        parseExceptionToMapObject(callException)
                    )
                }
            }

            SignedCallAPI.getInstance().call(context,
                receiverCuid,
                callContext,
                callOptions,
                outgoingCallResponse
            )
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

    override fun getBackToCall(result: Result) {
        val success = SignedCallAPI.getInstance().callController?.getBackToCall(context)
        result.success(success)
    }

    override fun getCallState(result: Result) {
        val callState = SignedCallAPI.getInstance().callController?.callState?.formattedCallState()
        result.success(callState)
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

    private fun handleBackgroundEventHandler(call: MethodCall, result: Result) {
        val dispatcherHandle = Utils.parseLong(call.argument(DISPATCHER_HANDLE))
        val callbackHandle = Utils.parseLong(call.argument(CALLBACK_HANDLE))
        val suffix = when (call.method) {
            REGISTER_BACKGROUND_CALL_EVENT_HANDLER -> Constants.ISOLATE_SUFFIX_CALL_EVENT_CALLBACK
            REGISTER_BACKGROUND_MISSED_CALL_ACTION_CLICKED_HANDLER -> Constants.ISOLATE_SUFFIX_MISSED_CALL_ACTION_CLICKED_CALLBACK
            else -> return
        }

        if (dispatcherHandle != null && callbackHandle != null) {
            IsolateHandlePreferences.saveCallbackKeys(context, dispatcherHandle, callbackHandle, suffix)
        }

        result.success(null)
    }

    //Sends the real-time changes in the call-state in an observable event-stream
    override fun streamCallEvent(callEventResult: Map<String, Any>) {
        Utils.log(message = "Streaming call-event to event-channel with payload: $callEventResult")
        CallEventStreamHandler.eventSink?.success(callEventResult)
    }

    //Sends the missed call CTA click in an observable event stream
    override fun streamMissedCallCtaClick(clickResult: Map<String, Any>) {
        Utils.log(message = "Streaming missed-call CTA click to event-channel with payload: $clickResult")
        MissedCallActionEventStreamHandler.eventSink?.success(clickResult)
    }
}
