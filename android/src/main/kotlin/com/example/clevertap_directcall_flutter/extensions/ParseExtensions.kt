package com.example.clevertap_directcall_flutter.extensions

import com.clevertap.android.directcall.models.MissedCallNotificationOpenResult
import com.example.clevertap_directcall_flutter.Constants.KEY_ACTION
import com.example.clevertap_directcall_flutter.Constants.KEY_ACTION_ID
import com.example.clevertap_directcall_flutter.Constants.KEY_ACTION_LABEL
import com.example.clevertap_directcall_flutter.Constants.KEY_CALLEE_CUID
import com.example.clevertap_directcall_flutter.Constants.KEY_CALLER_CUID
import com.example.clevertap_directcall_flutter.Constants.KEY_CALL_CONTEXT
import com.example.clevertap_directcall_flutter.Constants.KEY_CALL_DETAILS

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