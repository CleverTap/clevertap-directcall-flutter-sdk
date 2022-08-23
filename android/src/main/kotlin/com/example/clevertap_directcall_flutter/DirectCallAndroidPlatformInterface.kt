package com.example.clevertap_directcall_flutter

import androidx.annotation.NonNull
import com.clevertap.android.directcall.init.DirectCallInitOptions
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface DirectCallAndroidPlatformInterface {
    fun initDirectCallSdk(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result)

    fun initiateVoipCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result)
}