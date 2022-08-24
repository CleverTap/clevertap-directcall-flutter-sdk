package com.example.clevertap_directcall_flutter

import android.content.Context
import com.example.clevertap_directcall_flutter.util.Constants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

abstract class FlutterPluginLifecycleHandler :
    FlutterPlugin {
    /// The MethodChannel that will establish the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    lateinit var methodChannel: MethodChannel
    lateinit var eventChannel: EventChannel
    lateinit var methodCallHandler: MethodChannel.MethodCallHandler
    lateinit var context: Context
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
        methodChannel.setMethodCallHandler(null)
    }

    private fun setupPlugin(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/methods")
        methodChannel.setMethodCallHandler(methodCallHandler)
        eventChannel = EventChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/events")
        context = binding.applicationContext

        //Call below callback only when the plugin setup is completed
        onPluginSetupCompleteListener()
    }
}