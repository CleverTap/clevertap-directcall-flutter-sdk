import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clevertap_directcall_flutter.dart';
import 'clevertap_directcall_flutter_platform_interface.dart';

typedef DirectCallInitializationHandler = void Function(
    Map<String, dynamic> mapList);

/// An implementation of [ClevertapDirectcallFlutterPlatform] that uses method channels.
class MethodChannelClevertapDirectcallFlutter
    extends ClevertapDirectcallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('clevertap_directcall_flutter');

  late DirectCallInitializationHandler directCallInitializationHandler;

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
      case "onDirectCallDidInitialize":
        Map<String, dynamic> args = call.arguments;
        directCallInitializationHandler(args);
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
    directCallInitializationHandler = initHandler;
    _methodChannel
        .invokeMethod<String>('init', {'initOptions': initProperties});
  }
}
