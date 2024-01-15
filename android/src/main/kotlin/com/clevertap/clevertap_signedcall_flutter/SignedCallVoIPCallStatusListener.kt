package com.clevertap.clevertap_signedcall_flutter

import android.content.Context
import android.util.Log
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.clevertap_signedcall_flutter.extensions.toMap
import com.clevertap.clevertap_signedcall_flutter.isolate.CleverTapBackgroundIsolateRunner

open class SignedCallVoIPCallStatusListener {

    companion object {
        private val TAG = "SCVoIPStatusListener"

        @JvmStatic
        fun initialize(context: Context) {
            Log.i(TAG, "SignedCallVoIPCallStatusListener is registered!")

            SignedCallAPI.getInstance().registerVoIPCallStatusListener { callStatusDetails ->

                Log.i(TAG, "callStatusReceived in SignedCallVoIPCallStatusListener!")
                CleverTapBackgroundIsolateRunner.startBackgroundIsolate(
                    context,
                    "onBackgroundCallEvent",
                    callStatusDetails.toMap()
                )
            }
        }
    }
}