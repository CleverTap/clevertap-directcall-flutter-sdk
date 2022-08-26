package com.example.clevertap_directcall_flutter.plugin

import android.content.Context
import com.example.clevertap_directcall_flutter.Constants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

abstract class FlutterPluginLifecycleHandler : FlutterPlugin {
    /**
     * The MethodChannel that will used to establish the communication between Flutter and Android
     *
     * This local reference serves to register the plugin with the Flutter Engine and unregister it
     * when the Flutter Engine is detached from the Activity
     */
    var methodChannel: MethodChannel? = null
    private lateinit var methodCallHandler: MethodChannel.MethodCallHandler

    /**
     * The EventChannel that will used to create pipeline of a data stream from Android to Flutter
     *
     * This local reference serves to create the pipeline and set the streamHandler
     *
     */
    var callEventChannel: EventChannel? = null
    var missedCallActionClickEventChannel: EventChannel? = null

    var context: Context? = null
    private lateinit var onPluginSetupCompleteListener: () -> Unit

    fun setupFlutterPlugin(
        methodCallHandler: MethodChannel.MethodCallHandler,
        onPluginSetupCompleteListener: () -> Unit
    ) {
        this.methodCallHandler = methodCallHandler
        this.onPluginSetupCompleteListener = onPluginSetupCompleteListener
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setupPlugin(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        callEventChannel?.setStreamHandler(null)
        callEventChannel = null
        missedCallActionClickEventChannel?.setStreamHandler(null)
        missedCallActionClickEventChannel = null
    }

    private fun setupPlugin(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/methods")
        methodChannel!!.setMethodCallHandler(methodCallHandler)
        callEventChannel =
            EventChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/events/call_event")
        missedCallActionClickEventChannel = EventChannel(
            binding.binaryMessenger,
            "${Constants.CHANNEL_NAME}/events/missed_call_action_click"
        )

        context = binding.applicationContext

        //Call below callback only when the plugin setup is completed
        onPluginSetupCompleteListener()
    }
}