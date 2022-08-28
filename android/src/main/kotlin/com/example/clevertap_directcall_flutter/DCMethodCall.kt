package com.example.clevertap_directcall_flutter

object DCMethodCall {
    //Flutter to Platform
    const val INIT = "init"
    const val CALL = "call"
    const val LOGOUT = "logout"
    const val IS_ENABLED = "isEnabled"
    const val HANG_UP_CALL = "hangUpCall"
    const val LOGGING = "logging"

    //Platform to Flutter
    const val ON_DIRECT_CALL_DID_INITIALIZE = "onDirectCallDidInitialize"
    const val ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE = "onDirectCallDidVoIPCallInitiate"
}