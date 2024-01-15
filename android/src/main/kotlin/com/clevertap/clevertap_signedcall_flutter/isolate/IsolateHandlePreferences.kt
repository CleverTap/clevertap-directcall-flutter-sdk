package com.clevertap.clevertap_signedcall_flutter.isolate

import android.content.Context
import android.content.SharedPreferences

object IsolateHandlePreferences {

    private const val SHARED_PREFS_FILE_NAME = "clevertap_flutter_plugin"
    private const val CALLBACK_DISPATCHER_HANDLE_KEY = "com.clevertap.clevertap_plugin.CALLBACK_DISPATCHER_HANDLE_KEY"
    private const val USER_CALLBACK_HANDLE_KEY = "com.clevertap.clevertap_plugin.CALLBACK_HANDLE_KEY"

    const val BACKGROUND_ISOLATE_CALL_EVENT = "onBackgroundCallEvent"
    const val BACKGROUND_ISOLATE_MISSED_CALL_ACTION_CLICKED = "onBackgroundMissedCallActionClicked"

    private fun getPreferences(context: Context): SharedPreferences {
        return context.getSharedPreferences(SHARED_PREFS_FILE_NAME, Context.MODE_PRIVATE)
    }

    /**
     * Sets the Dart callback handle for the Dart methods that are,
     * - responsible for initializing the background Dart isolate, preparing it to receive
     * Dart callback tasks requests.
     * - responsible for handling messaging events in the background.
     */
    fun saveCallbackKeys(
        context: Context?, dispatcherCallbackHandle: Long, callbackHandle: Long, callbackHandleSuffix: String
    ) {
        context?.let {
            val editor = getPreferences(it).edit()
            editor.putLong(CALLBACK_DISPATCHER_HANDLE_KEY, dispatcherCallbackHandle).apply()
            editor.putLong("$USER_CALLBACK_HANDLE_KEY#$callbackHandleSuffix", callbackHandle).apply()
        }
    }

    fun getCallbackDispatcherHandle(context: Context): Long {
        return getPreferences(context).getLong(CALLBACK_DISPATCHER_HANDLE_KEY, 0)
    }

    fun getUserCallbackHandle(context: Context, callbackHandleSuffix: String): Long {
        return getPreferences(context).getLong("$USER_CALLBACK_HANDLE_KEY#$callbackHandleSuffix", 0)
    }
}
