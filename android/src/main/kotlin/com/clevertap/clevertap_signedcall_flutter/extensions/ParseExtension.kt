package com.clevertap.clevertap_signedcall_flutter.extensions

import com.clevertap.android.signedcall.enums.VoIPCallStatus
import com.clevertap.android.signedcall.init.SignedCallAPI
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
    val callDetailsMap = mapOf<String, String>(
        KEY_CALLER_CUID to this.callDetails.callerCuid,
        KEY_CALLEE_CUID to this.callDetails.calleeCuid,
        KEY_CALL_CONTEXT to this.callDetails.callContext
    )
    resultMap[KEY_ACTION] = actionMap
    resultMap[KEY_CALL_DETAILS] = callDetailsMap
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

fun VoIPCallStatus.formattedCallEvent(): String {
    return when (this) {
        VoIPCallStatus.CALL_IS_PLACED -> "CallIsPlaced"
        VoIPCallStatus.CALL_CANCELLED -> "Cancelled"
        VoIPCallStatus.CALL_DECLINED -> "Declined"
        VoIPCallStatus.CALL_MISSED -> "Missed"
        VoIPCallStatus.CALL_ANSWERED -> "Answered"
        VoIPCallStatus.CALL_IN_PROGRESS -> "CallInProgress"
        VoIPCallStatus.CALL_OVER -> "Ended"
        VoIPCallStatus.CALLEE_BUSY_ON_ANOTHER_CALL -> "ReceiverBusyOnAnotherCall"
        VoIPCallStatus.CALL_DECLINED_DUE_TO_LOGGED_OUT_CUID -> "DeclinedDueToLoggedOutCuid"
        VoIPCallStatus.CALL_DECLINED_DUE_TO_NOTIFICATIONS_DISABLED -> "DeclinedDueToNotificationsDisabled"
        VoIPCallStatus.CALLEE_MICROPHONE_PERMISSION_NOT_GRANTED -> "DeclinedDueToMicrophonePermissionsNotGranted"
    }
}


/**
 * Converts CallDetails to a Map.
 *
 * @return A Map representation of CallDetails.
 */
fun CallDetails.toMap(): Map<String, Any> {
    return mapOf(
        "callerCuid" to callerCuid,
        "calleeCuid" to calleeCuid,
        "callContext" to callContext,
        "initiatorImage" to initiatorImage,
        "receiverImage" to receiverImage
    )
}