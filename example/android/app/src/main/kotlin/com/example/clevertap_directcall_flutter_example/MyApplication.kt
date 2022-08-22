package com.example.clevertap_directcall_flutter_example

import android.app.Application
import com.clevertap.android.directcall.fcm.DirectCallNotificationHandler
import com.clevertap.android.directcall.init.DirectCallAPI
import com.clevertap.android.sdk.ActivityLifecycleCallback

import com.clevertap.android.sdk.CleverTapAPI

class MyApplication : Application() {

    override fun onCreate() {
        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.VERBOSE)
        DirectCallAPI.setDebugLevel(DirectCallAPI.DCLogLevel.VERBOSE)
        CleverTapAPI.setNotificationHandler(DirectCallNotificationHandler())
        ActivityLifecycleCallback.register(this)
        super.onCreate()
    }
}