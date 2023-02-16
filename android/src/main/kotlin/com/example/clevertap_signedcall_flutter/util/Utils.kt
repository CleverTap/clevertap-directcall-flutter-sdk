package com.example.clevertap_signedcall_flutter.util

import android.annotation.SuppressLint
import android.util.Log
import com.clevertap.android.sdk.inapp.CTLocalInApp
import com.clevertap.android.signedcall.exception.CallException
import com.clevertap.android.signedcall.exception.InitException
import com.clevertap.android.signedcall.init.SignedCallAPI
import com.clevertap.android.signedcall.models.MissedCallAction
import com.clevertap.android.signedcall.models.SignedCallScreenBranding
import com.example.clevertap_signedcall_flutter.Constants
import com.example.clevertap_signedcall_flutter.Constants.DARK_THEME
import com.example.clevertap_signedcall_flutter.Constants.KEY_BG_COLOR
import com.example.clevertap_signedcall_flutter.Constants.KEY_BUTTON_THEME
import com.example.clevertap_signedcall_flutter.Constants.KEY_FONT_COLOR
import com.example.clevertap_signedcall_flutter.Constants.KEY_LOGO_URL
import com.example.clevertap_signedcall_flutter.Constants.LOG_TAG
import org.json.JSONObject

object Utils {

    @SuppressLint("RestrictedApi")
    @JvmStatic
    fun log(tag:String = LOG_TAG, message: String) {
        when(SignedCallAPI.getDebugLevel()) {
            SignedCallAPI.LogLevel.VERBOSE -> {
                Log.v(tag, message)
            }
            SignedCallAPI.LogLevel.DEBUG -> {
                Log.d(tag, message)
            }
            SignedCallAPI.LogLevel.INFO -> {
                Log.i(tag, message)
            }
        }
    }

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
     * parses into the [SignedCallScreenBranding] object
     */
    @JvmStatic
    @Throws(Exception::class)
    fun parseBrandingFromInitOptions(brandingMap: Map<*, *>): SignedCallScreenBranding {
        val bgColor = brandingMap[KEY_BG_COLOR] as String
        val fontColor = brandingMap[KEY_FONT_COLOR] as String
        val logoUrl = brandingMap[KEY_LOGO_URL] as String
        val buttonTheme = brandingMap[KEY_BUTTON_THEME] as String

        return SignedCallScreenBranding(
            bgColor, fontColor, logoUrl,
            if (buttonTheme == DARK_THEME)
                SignedCallScreenBranding.ButtonTheme.DARK
            else
                SignedCallScreenBranding.ButtonTheme.LIGHT
        )
    }

    /**
     * Retrieves the missed call actions from the input initProperties object and
     * parses into the list of [MissedCallAction]
     */
    @JvmStatic
    @Throws(Exception::class)
    fun parseMissedCallActionsFromInitOptions(missedCallActionsMap: Map<*, *>): List<MissedCallAction> {
        return missedCallActionsMap.toList().map {
            MissedCallAction(
                it.first as String?,
                it.second as String?
            )
        }
    }


    fun parsePushPrimerConfigFromInitOptions(objectMap: Map<*, *>): JSONObject? {
        var inAppType: CTLocalInApp.InAppType? = null
        var titleText: String? = null
        var messageText: String? = null
        var positiveBtnText: String? = null
        var negativeBtnText: String? = null
        var backgroundColor: String? = null
        var btnBorderColor: String? = null
        var titleTextColor: String? = null
        var messageTextColor: String? = null
        var btnTextColor: String? = null
        var imageUrl: String? = null
        var btnBackgroundColor: String? = null
        var btnBorderRadius: String? = null
        var fallbackToSettings = false
        var followDeviceOrientation = false
        for ((configKey, value) in objectMap) {
            try {
                if ("inAppType" == configKey) {
                    inAppType = inAppTypeFromString(value as String)
                }
                if ("titleText" == configKey) {
                    titleText = value as String
                }
                if ("messageText" == configKey) {
                    messageText = value as String
                }
                if ("followDeviceOrientation" == configKey) {
                    followDeviceOrientation = value as Boolean
                }
                if ("positiveBtnText" == configKey) {
                    positiveBtnText = value as String
                }
                if ("negativeBtnText" == configKey) {
                    negativeBtnText = value as String
                }
                if ("fallbackToSettings" == configKey) {
                    fallbackToSettings = value as Boolean
                }
                if ("backgroundColor" == configKey) {
                    backgroundColor = value as String
                }
                if ("btnBorderColor" == configKey) {
                    btnBorderColor = value as String
                }
                if ("titleTextColor" == configKey) {
                    titleTextColor = value as String
                }
                if ("messageTextColor" == configKey) {
                    messageTextColor = value as String
                }
                if ("btnTextColor" == configKey) {
                    btnTextColor = value as String
                }
                if ("imageUrl" == configKey) {
                    imageUrl = value as String
                }
                if ("btnBackgroundColor" == configKey) {
                    btnBackgroundColor = value as String
                }
                if ("btnBorderRadius" == configKey) {
                    btnBorderRadius = value as String
                }
            } catch (t: Throwable) {
                Log.e(
                    "CleverTapError", "Invalid parameters in LocalInApp config"
                            + t.getLocalizedMessage()
                )
                return null
            }
        }

        //creates the builder instance of localInApp with all the required parameters
        val builderWithRequiredParams: CTLocalInApp.Builder.Builder6 =
            getLocalInAppBuilderWithRequiredParam(
                inAppType, titleText, messageText, followDeviceOrientation, positiveBtnText,
                negativeBtnText
            )

        //adds the optional parameters to the builder instance
        if (backgroundColor != null) {
            builderWithRequiredParams.setBackgroundColor(backgroundColor)
        }
        if (btnBorderColor != null) {
            builderWithRequiredParams.setBtnBorderColor(btnBorderColor)
        }
        if (titleTextColor != null) {
            builderWithRequiredParams.setTitleTextColor(titleTextColor)
        }
        if (messageTextColor != null) {
            builderWithRequiredParams.setMessageTextColor(messageTextColor)
        }
        if (btnTextColor != null) {
            builderWithRequiredParams.setBtnTextColor(btnTextColor)
        }
        if (imageUrl != null) {
            builderWithRequiredParams.setImageUrl(imageUrl)
        }
        if (btnBackgroundColor != null) {
            builderWithRequiredParams.setBtnBackgroundColor(btnBackgroundColor)
        }
        if (btnBorderRadius != null) {
            builderWithRequiredParams.setBtnBorderRadius(btnBorderRadius)
        }
        builderWithRequiredParams.setFallbackToSettings(fallbackToSettings)
        val localInAppConfig: JSONObject = builderWithRequiredParams.build()
        Log.i(
            "CTLocalInAppConfig", "LocalInAppConfig for push primer prompt: "
                    + localInAppConfig
        )
        return localInAppConfig
    }

    /**
     * Creates an instance of the [CTLocalInApp.Builder.Builder6] with the required parameters.
     *
     * @return the [CTLocalInApp.Builder.Builder6] instance
     */
    private fun getLocalInAppBuilderWithRequiredParam(
        inAppType: CTLocalInApp.InAppType?,
        titleText: String?, messageText: String?,
        followDeviceOrientation: Boolean, positiveBtnText: String?,
        negativeBtnText: String?
    ): CTLocalInApp.Builder.Builder6 {

        //throws exception if any of the required parameter is missing
        if (inAppType == null || titleText == null || messageText == null || positiveBtnText == null || negativeBtnText == null) {
            throw IllegalArgumentException("Mandatory parameters are missing for LocalInApp config")
        }
        val builder: CTLocalInApp.Builder = CTLocalInApp.builder()
        return builder.setInAppType(inAppType)
            .setTitleText(titleText)
            .setMessageText(messageText)
            .followDeviceOrientation(followDeviceOrientation)
            .setPositiveBtnText(positiveBtnText)
            .setNegativeBtnText(negativeBtnText)
    }

    private fun inAppTypeFromString(inAppType: String?): CTLocalInApp.InAppType? {
        return if (inAppType == null) {
            null
        } else when (inAppType) {
            "half-interstitial" -> CTLocalInApp.InAppType.HALF_INTERSTITIAL
            "alert" -> CTLocalInApp.InAppType.ALERT
            else -> null
        }
    }
}

