package com.clevertap.clevertap_signedcall_flutter.isolate

import android.content.Context
import com.clevertap.clevertap_signedcall_flutter.SCAppContextHolder
import com.clevertap.clevertap_signedcall_flutter.util.Utils.log

/**
 * A runner class which abstracts the startup process for a background isolate.
 */
object SCBackgroundIsolateRunner {

    private const val TAG = "SCBackgroundIsolateRunner"

    private var backgroundIsolateExecutor: SCBackgroundIsolateExecutor? = null

    fun startBackgroundIsolate(context: Context?, methodName: String, payloadMap: Map<String, Any>) {
        if (context == null) {
            log(TAG, "Can't start a background isolate with a null appContext!")
            return
        }

        //persist the app context
        SCAppContextHolder.setApplicationContext(context)

        if (backgroundIsolateExecutor == null) {
            backgroundIsolateExecutor = SCBackgroundIsolateExecutor()
        }

        if (!backgroundIsolateExecutor!!.isDartBackgroundHandlerRegistered(context)) {
            log(
                TAG,
                "A background message could not be handled in Dart as background channel handler has not been registered."
            )
            return
        }

        backgroundIsolateExecutor!!.startBackgroundIsolate(context, methodName, payloadMap)
    }
}
