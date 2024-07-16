package com.clevertap.clevertap_signedcall_flutter

object SCMethodCall {
    //Flutter to Platform
    const val TRACK_SDK_VERSION = "trackSdkVersion"
    const val INIT = "init"
    const val CALL = "call"
    const val DISCONNECT_SIGNALLING_SOCKET = "disconnectSignallingSocket"
    const val GET_CALL_STATE = "getCallState"
    const val LOGOUT = "logout"
    const val HANG_UP_CALL = "hangUpCall"
    const val LOGGING = "logging"
    const val REGISTER_BACKGROUND_CALL_EVENT_HANDLER = "registerBackgroundCallEventHandler"
    const val REGISTER_BACKGROUND_MISSED_CALL_ACTION_CLICKED_HANDLER =
        "registerBackgroundMissedCallActionClickedHandler"
    const val ACK_MISSED_CALL_ACTION_CLICKED = "missedCallActionClicked#ack"

    //Platform to Flutter
    const val ON_SIGNED_CALL_DID_INITIALIZE = "onSignedCallDidInitialize"
    const val ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE = "onSignedCallDidVoIPCallInitiate"
}