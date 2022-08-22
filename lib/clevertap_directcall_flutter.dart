import 'clevertap_directcall_flutter_platform_interface.dart';

typedef DirectCallDidInitializeHandler = void Function(
    Map<String, dynamic> mapList);

/// Plugin class to handle the communication b/w the flutter app and Direct Call Native SDKs(Android/iOS)
class ClevertapDirectcallFlutter {
  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[handler]        - to get the initialization update(i.e. success/failure)
  Future<void> init(Map<String, dynamic> initProperties,
      DirectCallDidInitializeHandler handler) {
    return ClevertapDirectcallFlutterPlatform.instance
        .init(initProperties, handler);
  }
}