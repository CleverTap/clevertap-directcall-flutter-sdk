package com.clevertap.clevertap_signedcall_flutter.handlers

import android.content.Context
import android.util.Log
import com.clevertap.android.signedcall.interfaces.SCCancelCtaClickListener
import com.clevertap.android.signedcall.interfaces.SCNotificationClickListener
import com.clevertap.android.signedcall.models.CallDetails
import com.clevertap.android.signedcall.models.MissedCallNotificationOpenResult
import com.clevertap.clevertap_signedcall_flutter.Constants.LOG_TAG
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_FCM_NOTIFICATION_CANCEL_CTA_CLICKED
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_FCM_NOTIFICATION_CLICKED
import com.clevertap.clevertap_signedcall_flutter.isolate.SCBackgroundIsolateRunner
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import java.util.Timer
import java.util.TimerTask


/**
 * FCM Notification handler for notification clicks and cancel button clicks from FCM (Firebase Cloud Messaging) notifications.
 *
 * It processes two main types of actions:
 *
 *  * [Constants.ACTION_NOTIFICATION_CLICK] - When a notification is clicked.
 *  * [Constants.ACTION_CANCEL_CTA_CLICK] - When the Cancel CTA (Call To Action) is clicked.
 *
 *
 * Depending on the action, it triggers appropriate listeners
 */
class FCMNotificationHandler : SCNotificationClickListener, SCCancelCtaClickListener {

    companion object {

        const val ACK_TIMEOUT = 500L
        val ackTimeOutHandlerNotification = Timer()
        val ackTimeOutHandlerCancelCTA = Timer()

        // Cancels the acknowledgment timeout handler.
        fun resolveAckTimeOutHandlerNotification() {
            ackTimeOutHandlerNotification.cancel()
        }

        fun resolveAckTimeOutHandlerCancelCTA() {
            ackTimeOutHandlerCancelCTA.cancel()
        }
    }


    /**
     * Gets called from the SC SDK when the user taps on the FCM Notification
     *
     * @param context - the app context
     * @param callDetails  a [CallDetails] object having call related details
     */
    override fun onNotificationClick(context: Context, callDetails: CallDetails) {
        try {
            Utils.log(
                message = "FCM Notification is clicked" +
                        " Streaming to event-channel with payload: \n callId: " + callDetails.callId
                        + ", call context: " + callDetails.callContext
                        + ", receiver image: " + callDetails.receiverImage
                        + ", initiator image: " + callDetails.initiatorImage
                        + ", cuid of callee: " + callDetails.calleeCuid
                        + ", cuid of caller: " + callDetails.callerCuid
                        + ", remote context: " + callDetails.remoteContext
                        + ", channel: " + callDetails.channel.channelName
            )

            //Sends the real-time changes in an observable event-stream
            FCMNotificationEventStreamHandler.eventSink?.success(callDetails.toMap())
            Utils.log(message = "stream is sent for FCM Notification Clicked!!")

            ackTimeOutHandlerNotification.schedule(object : TimerTask() {
                override fun run() {
                    Utils.log(message = "inside ackTimeOutHandler for FCM Notification Clicked!")

                    Utils.runOnMainThread {
                        SCBackgroundIsolateRunner.startBackgroundIsolate(
                            context,
                            BACKGROUND_ISOLATE_FCM_NOTIFICATION_CLICKED, callDetails.toMap()
                        )
                    }
                }
            }, ACK_TIMEOUT)
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Exception while handling FCM Notification Click, " + e.localizedMessage)
        }
    }


    /**
     * Gets called from the SC SDK when the user taps on the FCM Notification Cancel CTA
     *
     * @param context - the app context
     * @param callDetails  a [CallDetails] object having call related details
     */
    override fun onCancelCtaClick(context: Context, callDetails: CallDetails) {
        try {
            Utils.log(
                message = "FCM Notification Cancel CTA is clicked" +
                        " Streaming to event-channel with payload: \n callId: " + callDetails.callId
                        + ", call context: " + callDetails.callContext
                        + ", receiver image: " + callDetails.receiverImage
                        + ", initiator image: " + callDetails.initiatorImage
                        + ", cuid of callee: " + callDetails.calleeCuid
                        + ", cuid of caller: " + callDetails.callerCuid
                        + ", remote context: " + callDetails.remoteContext
                        + ", channel: " + callDetails.channel.channelName
            )

            //Sends the real-time changes in an observable event-stream
            FCMNotificationCancelCTAEventStreamHandler.eventSink?.success(callDetails.toMap())
            Utils.log(message = "stream is sent for FCM Notification Cancel CTA Clicked!!")

            ackTimeOutHandlerCancelCTA.schedule(object : TimerTask() {
                override fun run() {
                    Utils.log(message = "inside ackTimeOutHandler for FCM Notification Cancel CTA CLicked!")

                    Utils.runOnMainThread {
                        SCBackgroundIsolateRunner.startBackgroundIsolate(
                            context,
                            BACKGROUND_ISOLATE_FCM_NOTIFICATION_CANCEL_CTA_CLICKED, callDetails.toMap()
                        )
                    }
                }
            }, ACK_TIMEOUT)
        } catch (e: Exception) {
            Log.d(LOG_TAG, "Exception while handling FCM Notification Cancel CTA Click, " + e.localizedMessage)
        }
    }
}
