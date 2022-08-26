package com.example.clevertap_directcall_flutter.util

import com.clevertap.android.directcall.exception.CallException
import com.clevertap.android.directcall.exception.InitException
import com.clevertap.android.directcall.models.DCCallScreenBranding
import com.clevertap.android.directcall.models.MissedCallActions
import com.clevertap.android.directcall.models.MissedCallNotificationOpenResult
import com.example.clevertap_directcall_flutter.Constants
import com.example.clevertap_directcall_flutter.Constants.DARK_THEME
import com.example.clevertap_directcall_flutter.Constants.KEY_BG_COLOR
import com.example.clevertap_directcall_flutter.Constants.KEY_BUTTON_THEME
import com.example.clevertap_directcall_flutter.Constants.KEY_FONT_COLOR
import com.example.clevertap_directcall_flutter.Constants.KEY_LOGO_URL
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

    /**
     * Retrieves the branding details from the input initProperties object and
     * parses into the [DCCallScreenBranding] object
     */
    @JvmStatic
    @Throws(Exception::class)
    fun parseBrandingFromInitOptions(brandingMap: Map<*, *>): DCCallScreenBranding {
        val bgColor = brandingMap[KEY_BG_COLOR] as String
        val fontColor = brandingMap[KEY_FONT_COLOR] as String
        val logoUrl = brandingMap[KEY_LOGO_URL] as String
        val buttonTheme = brandingMap[KEY_BUTTON_THEME] as String

        return DCCallScreenBranding(
            bgColor, fontColor, logoUrl,
            if (buttonTheme == DARK_THEME)
                DCCallScreenBranding.ButtonTheme.DARK
            else
                DCCallScreenBranding.ButtonTheme.LIGHT
        )
    }

    /**
     * Retrieves the missed call actions from the input initProperties object and
     * parses into the list of [MissedCallActions]
     */
    @JvmStatic
    @Throws(Exception::class)
    fun parseMissedCallActionsFromInitOptions(missedCallActionsMap: Map<*, *>): List<MissedCallActions> {
        return missedCallActionsMap.toList().map {
            MissedCallActions(
                it.first as String?,
                it.second as String?
            )
        }
    }
}

