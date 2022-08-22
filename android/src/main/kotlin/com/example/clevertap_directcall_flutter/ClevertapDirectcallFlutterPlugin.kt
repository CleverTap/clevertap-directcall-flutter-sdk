package com.example.clevertap_directcall_flutter

import android.content.Context
import android.widget.Toast
import androidx.annotation.NonNull
import com.clevertap.android.directcall.exception.InitException
import com.clevertap.android.directcall.init.DirectCallAPI
import com.clevertap.android.directcall.init.DirectCallInitOptions
import com.clevertap.android.directcall.interfaces.DirectCallInitResponse
import com.clevertap.android.sdk.CleverTapAPI
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.util.*


/** ClevertapDirectcallFlutterPlugin */
class ClevertapDirectcallFlutterPlugin : FlutterPlugin, MethodCallHandler,
    DirectCallAndroidPlatformInterface {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var cleverTapAPI: CleverTapAPI? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setupPlugin(flutterPluginBinding)
    }

    private fun setupPlugin(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "clevertap_directcall_flutter")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
        cleverTapAPI = CleverTapAPI.getDefaultInstance(context);
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "init") {
            initDirectCallSdk(call, result)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun initDirectCallSdk(call: MethodCall, result: Result) {
        val initOptions = call.argument<Map<String, Any>>("initOptions")

        try {
            val initJson = initOptions?.let {JSONObject(initOptions["initJson"] as String) }
            val allowPersistSocketConnection =
                initOptions?.getOrElse("allowPersistSocketConnection") { false } as Boolean

            val directCallInitBuilder =
                DirectCallInitOptions.Builder(initJson, allowPersistSocketConnection)
                    .enableReadPhoneState(true)
                    .build()

            DirectCallAPI.getInstance()
                .init(
                    context,
                    directCallInitBuilder,
                    cleverTapAPI,
                    object : DirectCallInitResponse {
                        override fun onSuccess() {
                            Toast.makeText(
                                context,
                                "Direct Call SDK Initialized!",
                                Toast.LENGTH_LONG
                            ).show()
                        }

                        override fun onFailure(initException: InitException) {
                            Toast.makeText(
                                context,
                                "DC Init failed: " + initException.errorCode + "=" + initException.message,
                                Toast.LENGTH_LONG
                            ).show()
                        }
                    })
        } catch (e: Exception) {
            e.printStackTrace()
            //TODO : add error reporting here
        }
    }

}
