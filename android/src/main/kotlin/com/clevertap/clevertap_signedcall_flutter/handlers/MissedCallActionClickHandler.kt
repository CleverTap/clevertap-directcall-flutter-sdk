package com.clevertap.clevertap_signedcall_flutter.handlers

import android.content.Context
import android.util.Log
import com.clevertap.android.signedcall.interfaces.MissedCallNotificationOpenedHandler
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import com.clevertap.clevertap_signedcall_flutter.Constants.LOG_TAG
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.isolate.SCBackgroundIsolateRunner
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import java.util.Timer
import java.util.TimerTask

/**
 * Missed Call CTA handler for SignedCall Missed Call Notifications
 */
class MissedCallActionClickHandler : MissedCallNotificationOpenedHandler {

    companion object {

        const val ACK_TIMEOUT = 500L
        val ackTimeOutHandler = Timer()

        // Cancels the acknowledgment timeout handler.
        fun resolveAckTimeOutHandler() {
            ackTimeOutHandler.cancel()
        }
    }

    /**
     * Gets called from the SC SDK when the user taps on the missed call CTA
     *
     * @param context - the app context
     * @param result  a [MissedCallNotificationOpenResult] object having call related details
     */
    override fun onMissedCallNotificationOpened(
        context: Context,
        result: MissedCallNotificationOpenResult
    ) {
        try {
            Utils.log(
                message = "Missed call action button clicked!" +
                        " Streaming to event-channel with payload: \n actionID: " + result.action.actionID
                        + ", actionLabel: " + result.action.actionLabel
                        + ", context of call: " + result.callDetails.callContext
                        + ", cuid of caller: " + result.callDetails.callerCuid
                        + ", cuid of callee: " + result.callDetails.calleeCuid
                        + ", initiator-image: " + result.callDetails.initiatorImage
                        + ", receiver-image: " + result.callDetails.receiverImage
                        + ", remote-context: " + result.callDetails.remoteContext

            )

            //Sends the real-time changes in the call-state in an observable event-stream
            MissedCallActionEventStreamHandler.eventSink?.success(result.toMap())
            Utils.log(message = "stream is sent!")

            ackTimeOutHandler.schedule(object : TimerTask() {
                override fun run() {
                    Utils.log(message = "inside ackTimeOutHandler!")

                    Utils.runOnMainThread {
                        SCBackgroundIsolateRunner.startBackgroundIsolate(
                            context,
                            BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED, result.toMap()
                        )
                    }
                }
            }, ACK_TIMEOUT)
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Exception while handling missed call CTA action, " + e.localizedMessage)
        }
    }
}