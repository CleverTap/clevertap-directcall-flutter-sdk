package com.example.clevertap_directcall_flutter.util

import com.clevertap.android.directcall.exception.CallException
import com.clevertap.android.directcall.exception.InitException

object Utils {

    /**
     * Parses the initialization or call exception to a map by populating errorCode, message and explanation of the exception
     */
    @JvmStatic
    fun parseExceptionToMap(exception: Any): HashMap<String, Any> {
        val error = if (exception is InitException) exception else exception as CallException
        val errorMap = HashMap<String, Any>()
        errorMap[Constants.KEY_ERROR_CODE] = error.errorCode
        errorMap[Constants.KEY_ERROR_MESSAGE] = error.message!!
        errorMap[Constants.KEY_ERROR_DESCRIPTION] = error.explanation
        return errorMap
    }
}