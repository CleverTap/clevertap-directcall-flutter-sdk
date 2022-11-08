package com.example.clevertap_signedcall_flutter

object SCMethodCall {
    //Flutter to Platform
    const val INIT = "init"
    const val CALL = "call"
    const val LOGOUT = "logout"
    const val IS_ENABLED = "isEnabled"
    const val HANG_UP_CALL = "hangUpCall"
    const val LOGGING = "logging"

    //Platform to Flutter
    const val ON_SIGNED_CALL_DID_INITIALIZE = "onSignedCallDidInitialize"
    const val ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE = "onSignedCallDidVoIPCallInitiate"
}