package com.clevertap.clevertap_signedcall_flutter

import android.content.Context
import android.util.Log
import com.clevertap.clevertap_signedcall_flutter.util.Utils
import com.clevertap.clevertap_signedcall_flutter.util.Utils.log

/**
 * This class holds the application context in a static reference
 */
object SCAppContextHolder {

    private const val TAG = "SCAppContextHolder"
    private var applicationContext: Context? = null

    fun getApplicationContext(): Context? {
        return applicationContext
    }

    fun setApplicationContext(applicationContext: Context) {
        log(TAG, "set application context.")
        SCAppContextHolder.applicationContext = applicationContext
    }
}