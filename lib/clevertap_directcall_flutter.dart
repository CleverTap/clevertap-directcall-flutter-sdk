import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';

import 'call_events.dart';
import 'clevertap_directcall_flutter_platform_interface.dart';

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

  ///Initiates a VoIP call
  ///
  ///[callProperties]  - configuration for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  Future<void> call(
      {required Map<String, dynamic> callProperties,
      required DirectCallVoIPCallHandler voIPCallHandler}) {
    return ClevertapDirectcallFlutterPlatform.instance
        .call(callProperties, voIPCallHandler);
  }

  ///Returns the listener to listen the call-events stream
  Stream<CallEvent> get callEventListener =>
      ClevertapDirectcallFlutterPlatform.instance.callEventsListener;
}
