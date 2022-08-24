import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'call_events.dart';
import 'clevertap_directcall_flutter_method_channel.dart';

abstract class ClevertapDirectcallFlutterPlatform extends PlatformInterface {
  /// Constructs a ClevertapDirectcallFlutterPlatform.
  ClevertapDirectcallFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ClevertapDirectcallFlutterPlatform _instance =
      MethodChannelClevertapDirectcallFlutter();

  /// The default instance of [ClevertapDirectcallFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelClevertapDirectcallFlutter].
  static ClevertapDirectcallFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ClevertapDirectcallFlutterPlatform] when
  /// they register themselves.
  static set instance(ClevertapDirectcallFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for the initialization
  ///[initHandler]    - to handle the initialization success or failure
  Future<void> init(
      Map<String, dynamic> initProperties, DirectCallInitHandler initHandler);

  ///Initiates a VoIP call
  ///
  ///[callProperties]  - configuration for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  Future<void> call(Map<String, dynamic> callProperties,
      DirectCallVoIPCallHandler voIPCallHandler);

  Stream<CallEvent> get callEventsListener;
}
