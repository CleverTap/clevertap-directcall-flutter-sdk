package com.clevertap.signedcall_flutter_example

import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.clevertap.android.signedcall.fcm.SignedCallNotificationHandler
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.example.clevertap_signedcall_flutter.SCApplication

class MyApplication : SCApplication() {

    override fun onCreate() {
        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.VERBOSE)
        SignedCallAPI.setDebugLevel(SignedCallAPI.LogLevel.VERBOSE)
        CleverTapAPI.setSignedCallNotificationHandler(SignedCallNotificationHandler())
        ActivityLifecycleCallback.register(this)
        super.onCreate()
    }
}