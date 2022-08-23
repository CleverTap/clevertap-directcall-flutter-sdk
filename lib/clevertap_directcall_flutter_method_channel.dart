import 'package:clevertap_directcall_flutter/src/constants.dart';
import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';
import 'package:clevertap_directcall_flutter/src/directcall_method_call_names.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clevertap_directcall_flutter_platform_interface.dart';

/// An implementation of [ClevertapDirectcallFlutterPlatform] that uses method channels.
class MethodChannelClevertapDirectcallFlutter
    extends ClevertapDirectcallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('clevertap_directcall_flutter');

  late DirectCallInitHandler initHandler;
  late DirectCallVoIPCallHandler voIPCallHandler;

  MethodChannelClevertapDirectcallFlutter() {
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  ///Handles the Platform-specific method-calls
  Future _platformCallHandler(MethodCall call) async {
    if (kDebugMode) {
      print(
          "_platformCallHandler called: \n invoked method - ${call.method} \n method-arguments -  ${call.arguments}");
    }

    switch (call.method) {
      case DCMethodCall.onDirectCallDidInitialize:
        Map<dynamic, dynamic>? args = call.arguments;
        initHandler(args?.cast<String, dynamic>());
        break;
      case DCMethodCall.onDirectCallDidVoIPCallInitiate:
        Map<dynamic, dynamic>? args = call.arguments;
        voIPCallHandler(args?.cast<String, dynamic>());
        break;
    }
  }

  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]    - to get the initialization update(i.e. success/failure)
  @override
  Future<void> init(Map<String, dynamic> initProperties,
      DirectCallInitHandler initHandler) async {
    this.initHandler = initHandler;
    _methodChannel.invokeMethod<String>(
        DCMethodCall.init, {argInitProperties: initProperties});
  }

  @override
  Future<void> call(Map<String, dynamic> callProperties,
      DirectCallVoIPCallHandler voIPCallHandler) async {
    this.voIPCallHandler = voIPCallHandler;
    _methodChannel.invokeMethod<String>(
        DCMethodCall.call, {argCallProperties: callProperties});
  }
}
