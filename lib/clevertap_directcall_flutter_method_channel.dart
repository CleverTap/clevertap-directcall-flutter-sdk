import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'clevertap_directcall_flutter_platform_interface.dart';

/// An implementation of [ClevertapDirectcallFlutterPlatform] that uses method channels.
class MethodChannelClevertapDirectcallFlutter extends ClevertapDirectcallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('clevertap_directcall_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
