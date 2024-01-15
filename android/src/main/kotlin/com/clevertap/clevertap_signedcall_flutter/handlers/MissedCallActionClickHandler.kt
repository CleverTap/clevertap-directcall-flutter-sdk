package com.clevertap.clevertap_signedcall_flutter.handlers

import android.content.Context
import android.util.Log
import com.clevertap.android.signedcall.interfaces.MissedCallNotificationOpenedHandler
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import com.clevertap.android.signedcall.utils.SignedCallUtils
import com.clevertap.clevertap_signedcall_flutter.Constants.LOG_TAG
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import com.example.clevertap_signedcall_flutter.isolate.CleverTapBackgroundIsolateRunner
import java.util.TimerTask

/**
 * Missed Call CTA handler for SignedCall Missed Call Notifications
 */
class MissedCallActionClickHandler : MissedCallNotificationOpenedHandler {

    companion object {
        val ackTimeOutHandler = Timer()

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
                message =  "Missed call action button clicked!"+
                        " Streaming to event-channel with payload: \n actionID: " + result.action.actionID
                        + ", actionLabel: " + result.action.actionLabel
                        + ", context of call: " + result.callDetails.callContext
                        + ", cuid of caller: " + result.callDetails.callerCuid
                        + ", cuid of callee: " + result.callDetails.calleeCuid
            )

            //Sends the real-time changes in the call-state in an observable event-stream
            Utils.log(message = "stream is sent!")
            MissedCallActionEventStreamHandler.eventSink?.success(result.toMap())
            ackTimeOutHandler.schedule(object : TimerTask() {
                override fun run() {
                    Utils.log(
                        message = "inside ackTimeOutHandler!"
                    )
                    SignedCallUtils.runOnMainThread {
                        CleverTapBackgroundIsolateRunner.startBackgroundIsolate(context,
                            "onBackgroundMissedCallActionClicked"
                            , result.toMap())
                    }
                }
            }, 1000)
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Exception while handling missed call CTA action, " + e.localizedMessage)
        }
    }
}