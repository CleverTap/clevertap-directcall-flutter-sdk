package com.clevertap.clevertap_signedcall_flutter

import android.content.Context
import android.util.Log

/**
 * This class holds the application context in a static reference which is used to start
 * a background isolate.
 */
object SCAppContextHolder {
    private const val TAG = "CTAppContextHolder"
    private var applicationContext: Context? = null

    fun getApplicationContext(): Context? {
        return applicationContext
    }

    fun setApplicationContext(applicationContext: Context) {
        Log.d(TAG, "received application context.")
        SCAppContextHolder.applicationContext = applicationContext
    }
}
