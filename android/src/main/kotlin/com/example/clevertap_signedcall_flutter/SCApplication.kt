package com.example.clevertap_signedcall_flutter

import android.util.Log
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.interfaces.SCVoIPCallStatusListener
import com.clevertap.android.signedcall.models.SCCallStatusDetails
import com.example.clevertap_signedcall_flutter.isolate.CleverTapBackgroundIsolateRunner
import io.flutter.app.FlutterApplication

open class SCApplication : FlutterApplication(), SCVoIPCallStatusListener {

    private val TAG = "SCApplication"

    override fun onCreate() {
        super.onCreate()

        SignedCallAPI.getInstance().registerVoIPCallStatusListener(this)
    }

    override fun callStatus(voIPCallStatus: SCCallStatusDetails?) {
        // Notification is clicked in the killed state
        Log.i(TAG, "callStatusReceived!")
        CleverTapBackgroundIsolateRunner.startBackgroundIsolate(this, voIPCallStatus)
    }
}
