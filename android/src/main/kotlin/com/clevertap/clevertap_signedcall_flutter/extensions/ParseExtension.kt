package com.clevertap.clevertap_signedcall_flutter.extensions

import com.clevertap.android.signedcall.enums.SCCallState
import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALLEE_BUSY_ON_ANOTHER_CALL
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALLEE_MICROPHONE_PERMISSION_BLOCKED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALLEE_MICROPHONE_PERMISSION_NOT_GRANTED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_ANSWERED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_CANCELLED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_CANCELLED_DUE_TO_RING_TIMEOUT
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_DECLINED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_DECLINED_DUE_TO_BUSY_ON_PSTN
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_DECLINED_DUE_TO_BUSY_ON_VOIP
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_DECLINED_DUE_TO_LOGGED_OUT_CUID
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_DECLINED_DUE_TO_NOTIFICATIONS_DISABLED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_FAILED_DUE_TO_INTERNAL_ERROR
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_IN_PROGRESS
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_IS_PLACED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_MISSED
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_OVER
import com.clevertap.android.signedcall.enums.VoIPCallStatus.CALL_RINGING
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.init.SignedCallInitConfiguration.SCSwipeOffBehaviour
import com.clevertap.android.signedcall.models.CallDetails
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import com.clevertap.android.signedcall.models.SCCallStatusDetails
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_ACTION
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_ACTION_ID
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_ACTION_LABEL
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALLEE_CUID
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALLER_CUID
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_CONTEXT
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_CALL_DETAILS
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_INITIATOR_IMAGE
import com.clevertap.clevertap_signedcall_flutter.Constants.KEY_RECEIVER_IMAGE

/**
 * Parses the [MissedCallNotificationOpenResult] instance to a map object
 * @return - returns a parsed map object
 */
fun MissedCallNotificationOpenResult.toMap(): HashMap<String, Any> {
    val resultMap = HashMap<String, Any>()
    val actionMap = mapOf<String, String>(
        KEY_ACTION_ID to this.action.actionID,
        KEY_ACTION_LABEL to this.action.actionLabel
    )
    resultMap[KEY_ACTION] = actionMap
    resultMap[KEY_CALL_DETAILS] = this.callDetails.toMap()
    return resultMap
}

/**
 * Parses the integer to the [SignedCallAPI.LogLevel]
 * @return - returns a parsed DCLogLevel value
 */
fun Int.toSignedCallLogLevel(): Int {
    return when (this) {
        -1 -> SignedCallAPI.LogLevel.OFF
        0 -> SignedCallAPI.LogLevel.INFO
        2 -> SignedCallAPI.LogLevel.DEBUG
        3 -> SignedCallAPI.LogLevel.VERBOSE
        else -> throw IllegalStateException("Invalid value of debug level")
    }
}

/**
 * Converts SCCallStatusDetails to a Map.
 *
 * @return A Map representation of SCCallStatusDetails.
 */
fun SCCallStatusDetails.toMap(): Map<String, Any> {
    return mapOf(
        "direction" to direction.toString(),
        "callDetails" to callDetails.toMap(),
        "callEvent" to callStatus.formattedCallEvent()
    )
}

/**
 * Converts [VoIPCallStatus] to a formatted string.
 *
 * @return A formatted call event string.
 */
fun VoIPCallStatus.formattedCallEvent(): String {
    return when (this) {
        CALL_IS_PLACED -> "CallIsPlaced"
        CALL_RINGING -> "Ringing"
        CALL_CANCELLED -> "Cancelled"
        CALL_CANCELLED_DUE_TO_RING_TIMEOUT -> "CancelledDueToRingTimeout"
        CALL_DECLINED -> "Declined"
        CALL_MISSED -> "Missed"
        CALL_ANSWERED -> "Answered"
        CALL_IN_PROGRESS -> "CallInProgress"
        CALL_OVER -> "Ended"
        CALLEE_BUSY_ON_ANOTHER_CALL -> "ReceiverBusyOnAnotherCall"
        CALL_DECLINED_DUE_TO_LOGGED_OUT_CUID -> "DeclinedDueToLoggedOutCuid"
        CALL_DECLINED_DUE_TO_NOTIFICATIONS_DISABLED -> "DeclinedDueToNotificationsDisabled"
        CALLEE_MICROPHONE_PERMISSION_NOT_GRANTED -> "DeclinedDueToMicrophonePermissionsNotGranted"
        CALLEE_MICROPHONE_PERMISSION_BLOCKED -> "DeclinedDueToMicrophonePermissionBlocked"
        CALL_DECLINED_DUE_TO_BUSY_ON_VOIP -> "DeclinedDueToBusyOnVoIP"
        CALL_DECLINED_DUE_TO_BUSY_ON_PSTN -> "DeclinedDueToBusyOnPSTN"
        CALL_FAILED_DUE_TO_INTERNAL_ERROR -> "FailedDueToInternalError"
        else -> "Unknown"
    }
}

/**
 * Converts [SCCallState] to a formatted string.
 *
 * @return A formatted call state string.
 */
fun SCCallState.formattedCallState(): String {
    return when (this) {
        SCCallState.OUTGOING_CALL -> "OutgoingCall"
        SCCallState.INCOMING_CALL -> "IncomingCall"
        SCCallState.ONGOING_CALL -> "OngoingCall"
        SCCallState.CLEANUP_CALL -> "CleanupCall"
        SCCallState.NO_CALL -> "NoCall"
        else -> "Unknown"
    }
}

/**
 * Converts CallDetails to a Map.
 *
 * @return A Map representation of CallDetails.
 */
fun CallDetails.toMap(): Map<String, Any> {
    return mapOf(
        KEY_CALLER_CUID to (callerCuid ?: ""),
        KEY_CALLEE_CUID to (calleeCuid ?: ""),
        KEY_CALL_CONTEXT to (callContext ?: ""),
        KEY_INITIATOR_IMAGE to initiatorImage,
        KEY_RECEIVER_IMAGE to receiverImage
    )
}