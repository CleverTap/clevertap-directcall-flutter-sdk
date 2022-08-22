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

  Future _platformCallHandler(MethodCall call) async {
    if (kDebugMode) {
      print("_platformCallHandler call ${call.method} ${call.arguments}");
    }

    switch (call.method) {
      case "onDirectCallDidInitialize":
        Map<dynamic, dynamic> args = call.arguments;
        directCallInitializationHandler(args.cast<String, dynamic>());
        break;
    }
  }

  @override
  Future<void> init(Map<String, dynamic> initProperties,
      DirectCallDidInitializeHandler initializeHandler) async {
    _methodChannel
        .invokeMethod<String>('init', {'initOptions': initProperties});
  }
}
