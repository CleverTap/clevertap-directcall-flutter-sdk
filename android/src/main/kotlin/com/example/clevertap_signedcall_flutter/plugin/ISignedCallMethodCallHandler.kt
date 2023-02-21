package com.example.clevertap_signedcall_flutter.plugin

import androidx.annotation.NonNull
import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import io.flutter.plugin.common.MethodCall

/**
 * Defines all the operations that needs to be performed via Signed Call Android SDK
 */
interface ISignedCallMethodCallHandler {
    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun setDebugLevel(call: MethodCall)

    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun initSignedCallSdk(call: MethodCall)

    /**
     * Defines implementation to initiate a VoIP call
     */
    fun initiateVoipCall(call: MethodCall)

    /**
     * Sends the real-time changes in the call-state in an observable event stream
     */
    fun streamCallEvent(event: VoIPCallStatus)

    /**
     * Disconnects the signalling socket
     */
    fun disconnectSignallingSocket()

    /**
     * Defines implementation to logout the Signed Call SDK session
     */
    fun logout()

    /**
     * Ends the active call, if any.
     */
    fun hangUpCall()
}