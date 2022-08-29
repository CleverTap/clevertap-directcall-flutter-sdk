package com.example.clevertap_directcall_flutter.plugin

import androidx.annotation.NonNull
import com.clevertap.android.directcall.javaclasses.VoIPCallStatus
import com.clevertap.android.directcall.models.MissedCallNotificationOpenResult
import io.flutter.plugin.common.MethodCall

/**
 * Defines all the operations that needs to be performed via Direct Call Android SDK
 */
interface IDirectCallTask {
    /**
     * Defines implementation to initialize the Direct Call Android SDK
     */
    fun setDebugLevel(@NonNull call: MethodCall)

    /**
     * Defines implementation to initialize the Direct Call Android SDK
     */
    fun initDirectCallSdk(@NonNull call: MethodCall)

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
     * Defines implementation to logout the Direct Call SDK session
     */
    fun logout()

    /**
     * Defines implementation to check whether the Direct Call SDK services(i.e. call initiation or reception)
     * are enabled or not.
     */
    fun isDirectCallSdkEnabled(): Boolean

    /**
     * Ends the active call, if any.
     */
    fun hangUpCall()
}