import 'clevertap_directcall_flutter_platform_interface.dart';

typedef DirectCallInitHandler = void Function(
    Map<String, dynamic>? directCallInitError);

/// Plugin class to handle the communication b/w the flutter app and Direct Call Native SDKs(Android/iOS)
class ClevertapDirectcallFlutter {
  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]        - to get the initialization update(i.e. success/failure)
  Future<void> init(
      {required Map<String, dynamic> initProperties,
      required DirectCallInitHandler initHandler}) {
    return ClevertapDirectcallFlutterPlatform.instance
        .init(initProperties, initHandler);
  }
}
