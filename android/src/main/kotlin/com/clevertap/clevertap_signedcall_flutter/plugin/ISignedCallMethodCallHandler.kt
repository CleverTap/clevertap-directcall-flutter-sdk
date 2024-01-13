package com.clevertap.clevertap_signedcall_flutter.plugin

import com.clevertap.android.signedcall.models.SCCallStatusDetails
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Defines all the operations that needs to be performed via Signed Call Android SDK
 */
interface ISignedCallMethodCallHandler {
    /**
     * Defines implementation to track the SDK version
     */
    fun trackSdkVersion(call: MethodCall, result: MethodChannel.Result)

    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun setDebugLevel(call: MethodCall, result: MethodChannel.Result)

    /**
     * Defines implementation to initialize the Signed Call Android SDK
     */
    fun initSignedCallSdk(call: MethodCall, result: MethodChannel.Result)

    /**
     * Defines implementation to initiate a VoIP call
     */
    fun initiateVoipCall(call: MethodCall, result: MethodChannel.Result)

    /**
     * Sends the real-time changes in the call-state in an observable event stream
     */
    fun streamCallEvent(callStatusDetails: SCCallStatusDetails)

    /**
     * Disconnects the signalling socket
     */
    fun disconnectSignallingSocket(result: MethodChannel.Result)

    /**
     * Defines implementation to logout the Signed Call SDK session
     */
    fun logout(result: MethodChannel.Result)

    /**
     * Ends the active call, if any.
     */
    fun hangUpCall(result: MethodChannel.Result)
}