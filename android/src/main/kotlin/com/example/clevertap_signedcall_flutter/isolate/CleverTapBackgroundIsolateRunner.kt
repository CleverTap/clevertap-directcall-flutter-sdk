package com.example.clevertap_signedcall_flutter.isolate

import android.content.Context
import android.util.Log
import com.clevertap.android.signedcall.models.SCCallStatusDetails
import com.example.clevertap_signedcall_flutter.SCAppContextHolder

/**
 * A runner class which abstracts the startup process for a background isolate.
 */
object CleverTapBackgroundIsolateRunner {
    private const val TAG = "CTBGIsolateRunner"

    private var backgroundIsolateExecutor: CleverTapBackgroundIsolateExecutor? = null

    fun startBackgroundIsolate(context: Context?, callStatus: SCCallStatusDetails) {

        if (context == null) {
            Log.d(TAG, "Can't start a background isolate with a null appContext!")
            return
        }

        //persist the app context

        //persist the app context
        SCAppContextHolder.setApplicationContext(context)

        if (backgroundIsolateExecutor == null) {
            backgroundIsolateExecutor = CleverTapBackgroundIsolateExecutor(callStatus)
        }

        if (!backgroundIsolateExecutor!!.isDartBackgroundHandlerRegistered()) {
            Log.w(TAG, "A background message could not be handled in Dart as no onKilledStateNotificationClicked handler has been registered.")
            return
        }

        backgroundIsolateExecutor!!.startBackgroundIsolate()
    }
}
