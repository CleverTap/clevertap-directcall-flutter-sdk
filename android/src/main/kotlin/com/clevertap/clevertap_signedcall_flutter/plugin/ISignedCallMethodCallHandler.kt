package com.clevertap.clevertap_signedcall_flutter.plugin

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
    fun streamCallEvent(callEventResult: Map<String, Any>)

    /**
     * Sends the missed call CTA click in an observable event stream
     */
    fun streamMissedCallCtaClick(clickResult: Map<String, Any>)

    /**
     * Disconnects the signalling socket
     */
    fun disconnectSignallingSocket(result: MethodChannel.Result)

    /**
     * Attempts to return to the active call screen.
     *
     * It checks if there is an active call and if the client is on a VoIP call.
     * If the both conditions are met, it launches the call screen.
     */
    fun getBackToCall(result: MethodChannel.Result)

    /**
     * Retrieves the current call state.
     *
     * @return The current call state.
     */
    fun getCallState(result: MethodChannel.Result)

    /**
     * Defines implementation to logout the Signed Call SDK session
     */
    fun logout(result: MethodChannel.Result)

    /**
     * Ends the active call, if any.
     */
    fun hangUpCall(result: MethodChannel.Result)
}