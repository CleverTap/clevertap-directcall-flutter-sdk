package com.example.clevertap_directcall_flutter.util

import com.clevertap.android.directcall.exception.CallException
import com.clevertap.android.directcall.exception.InitException
import com.example.clevertap_directcall_flutter.Constants
import org.json.JSONObject

object Utils {

    /**
     * Parses the initialization or call exception to a map by populating errorCode,
     * message and explanation of the exception.
     */
    @JvmStatic
    fun parseExceptionToMapObject(exception: Any): HashMap<String, Any> {
        val error = if (exception is InitException) exception else exception as CallException
        val errorMap = HashMap<String, Any>()
        errorMap[Constants.KEY_ERROR_CODE] = error.errorCode
        errorMap[Constants.KEY_ERROR_MESSAGE] = error.message!!
        errorMap[Constants.KEY_ERROR_DESCRIPTION] = error.explanation
        return errorMap
    }

    /**
     * Retrieves the initOptions details from the input initProperties object and parses into a JSONObject
     */
    @JvmStatic
    @Throws(Exception::class)
    fun parseInitOptionsFromInitProperties(initProperties: Map<String, Any>): JSONObject {
        val initOptionsJson = JSONObject()
        initOptionsJson.put(
            Constants.KEY_ACCOUNT_ID,
            initProperties[Constants.KEY_ACCOUNT_ID]
        )
        initOptionsJson.put(Constants.KEY_API_KEY, initProperties[Constants.KEY_API_KEY])
        initOptionsJson.put(Constants.KEY_CUID, initProperties[Constants.KEY_CUID])
        initOptionsJson.put(Constants.KEY_APP_ID, initProperties[Constants.KEY_APP_ID])
        initOptionsJson.put(Constants.KEY_NAME, initProperties[Constants.KEY_NAME])
        initOptionsJson.put(Constants.KEY_RINGTONE, initProperties[Constants.KEY_RINGTONE])
        return initOptionsJson
    }
}