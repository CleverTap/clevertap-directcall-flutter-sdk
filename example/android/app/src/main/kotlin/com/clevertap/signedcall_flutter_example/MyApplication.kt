package com.clevertap.signedcall_flutter_example

import android.app.Application
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.signedcall.fcm.SignedCallNotificationHandler
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.example.clevertap_signedcall_flutter.SignedCallVoIPCallStatusListener

class MyApplication : Application() {

    override fun onCreate() {
        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.VERBOSE)
        SignedCallAPI.setDebugLevel(SignedCallAPI.LogLevel.VERBOSE)
        SignedCallVoIPCallStatusListener.initialize(this)
        CleverTapAPI.setSignedCallNotificationHandler(SignedCallNotificationHandler())
        ActivityLifecycleCallback.register(this)
        super.onCreate()
    }
}