package com.example.clevertap_directcall_flutter.plugin

import android.content.Context
import com.example.clevertap_directcall_flutter.util.Constants
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel

abstract class FlutterPluginLifecycleHandler : FlutterPlugin {
    /**
     * The MethodChannel that will used to establish the communication between Flutter and Android
     *
     * This local reference serves to register the plugin with the Flutter Engine and unregister it
     * when the Flutter Engine is detached from the Activity
     */
    lateinit var methodChannel: MethodChannel
    private lateinit var methodCallHandler: MethodChannel.MethodCallHandler

    /**
     * The EventChannel that will used to create pipeline of a data stream from Android to Flutter
     *
     * This local reference serves to create the pipeline and set the streamHandler
     *
     */
    lateinit var eventChannel: EventChannel
    private lateinit var eventStreamHandler: EventChannel.StreamHandler
    var eventSink: EventSink? = null

    var context: Context? = null
    private lateinit var onPluginSetupCompleteListener: () -> Unit

    fun setupFlutterPlugin(
        methodCallHandler: MethodChannel.MethodCallHandler,
        eventStreamHandler: EventChannel.StreamHandler,
        onPluginSetupCompleteListener: () -> Unit
    ) {
        this.methodCallHandler = methodCallHandler
        this.eventStreamHandler = eventStreamHandler
        this.onPluginSetupCompleteListener = onPluginSetupCompleteListener
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setupPlugin(flutterPluginBinding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    private fun setupPlugin(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/methods")
        methodChannel.setMethodCallHandler(methodCallHandler)
        eventChannel = EventChannel(binding.binaryMessenger, "${Constants.CHANNEL_NAME}/events")
        eventChannel.setStreamHandler(eventStreamHandler);
        context = binding.applicationContext

        //Call below callback only when the plugin setup is completed
        onPluginSetupCompleteListener()
    }
}