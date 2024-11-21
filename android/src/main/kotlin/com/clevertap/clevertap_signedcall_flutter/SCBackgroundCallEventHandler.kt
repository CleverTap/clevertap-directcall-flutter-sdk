package com.clevertap.clevertap_signedcall_flutter

import android.content.Context
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.isolate.SCBackgroundIsolateRunner
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_CALL_EVENT
import com.clevertap.clevertap_signedcall_flutter.isolate.IsolateHandlePreferences.BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED
import com.clevertap.clevertap_signedcall_flutter.util.Utils

open class SCBackgroundCallEventHandler {

    companion object {

        @JvmStatic
        fun initialize(context: Context) {
            Utils.log(message = "SCBackgroundCallEventHandler is initialized!")

            SignedCallAPI.getInstance().registerVoIPCallStatusListener { data ->
                Utils.log(message = "VoIPCallStatusListener is invoked with payload: $data")
                SCBackgroundIsolateRunner.startBackgroundIsolate(
                    context, BACKGROUND_ISOLATE_CALL_EVENT, data.toMap()
                )
            }

            SignedCallAPI.getInstance().setMissedCallNotificationOpenedHandler {  _, result ->
                Utils.log(message = "MissedCallNotificationOpenedHandler is invoked with payload: ${result.toMap()}")
                SCBackgroundIsolateRunner.startBackgroundIsolate(
                    context,
                    BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED, result.toMap()
                )
            }
        }
    }
}