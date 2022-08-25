package com.example.clevertap_directcall_flutter

object DCMethodCallNames {
    //Flutter to Platform
    const val INIT = "int"
    const val CALL = "call"
    const val LOGOUT = "logout"
    const val IS_ENABLED = "isEnabled"
    const val HANG_UP_CALL = "hangUpCall"

    //Platform to Flutter
    const val ON_DIRECT_CALL_DID_INITIALIZE = "onDirectCallDidInitialize"
    const val ON_DIRECT_CALL_DID_VOIP_CALL_INITIATE = "onDirectCallDidVoIPCallInitiate"
}