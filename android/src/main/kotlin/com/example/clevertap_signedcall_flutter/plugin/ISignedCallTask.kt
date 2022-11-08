package com.example.clevertap_signedcall_flutter.plugin

import androidx.annotation.NonNull
import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import io.flutter.plugin.common.MethodCall

/**
 * Defines all the operations that needs to be performed via Signed Call Android SDK
 */
interface ISignedCallTask {
    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun setDebugLevel(@NonNull call: MethodCall)

    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun initSignedCallSdk(@NonNull call: MethodCall)

    /**
     * Defines implementation to initiate a VoIP call
     */
    fun initiateVoipCall(@NonNull call: MethodCall)

    /**
     * Sends the real-time changes in the call-state in an observable event stream
     */
    fun streamCallEvent(event: VoIPCallStatus)

    /**
     * Sends the payload result of a missed call action click in an observable event stream
     */
    fun streamMissedCallActionClickResult(result: MissedCallNotificationOpenResult)

    /**
     * Defines implementation to logout the Signed Call SDK session
     */
    fun logout()

    /**
     * Defines implementation to check whether the Signed Call SDK services(i.e. call initiation or reception)
     * are enabled or not.
     */
    fun isSignedCallSdkEnabled(): Boolean

    /**
     * Ends the active call, if any.
     */
    fun hangUpCall()
}