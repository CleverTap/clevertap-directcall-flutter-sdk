import 'package:clevertap_directcall_flutter/src/constants.dart';
import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';
import 'package:clevertap_directcall_flutter/src/directcall_method_calls.dart';
import 'package:clevertap_directcall_flutter/src/utils.dart';
import 'package:flutter/services.dart';

import 'call_events.dart';
import 'clevertap_directcall_flutter_platform_interface.dart';

/// An implementation of [ClevertapDirectcallFlutterPlatform] that uses method channels.
class MethodChannelClevertapDirectcallFlutter
    extends ClevertapDirectcallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('$channelName/methods');

  /// The event channel used to listen the data stream from the native platform.
  final EventChannel _eventChannel = const EventChannel('$channelName/events');

  Stream<CallEvent>? _callEventsListener;

  late DirectCallInitHandler _initHandler;
  late DirectCallVoIPCallHandler _voIPCallHandler;

  MethodChannelClevertapDirectcallFlutter() {
    //sets the methodCallHandler to receive the method calls from native platform
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  /// broadcasts the call events
  @override
  Stream<CallEvent> get callEventsListener {
    _callEventsListener ??= _eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => Utils.parseCallEvent(event));
    return _callEventsListener!;
  }

  ///Handles the Platform-specific method-calls
  Future _platformCallHandler(MethodCall call) async {
    print(
        "_platformCallHandler called: \n invoked method - ${call.method} \n method-arguments -  ${call.arguments}");

    switch (call.method) {
      case DCMethodCall.onDirectCallDidInitialize:
        Map<dynamic, dynamic>? args = call.arguments;
        _initHandler(args?.cast<String, dynamic>());
        break;
      case DCMethodCall.onDirectCallDidVoIPCallInitiate:
        Map<dynamic, dynamic>? args = call.arguments;
        _voIPCallHandler(args?.cast<String, dynamic>());
        break;
    }
  }

  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]    - to get the initialization update(i.e. success/failure)
  @override
  Future<void> init(
      Map<String, dynamic> initProperties, DirectCallInitHandler initHandler) {
    _initHandler = initHandler;
    return _methodChannel
        .invokeMethod(DCMethodCall.init, {argInitProperties: initProperties});
  }

  ///Initiates a VoIP call
  ///
  ///[callProperties]  - configuration for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  @override
  Future<void> call(Map<String, dynamic> callProperties,
      DirectCallVoIPCallHandler voIPCallHandler) {
    _voIPCallHandler = voIPCallHandler;
    return _methodChannel
        .invokeMethod(DCMethodCall.call, {argCallProperties: callProperties});
  }

  ///Logs out the user from the Direct Call SDK session
  @override
  Future<void> logout() {
    return _methodChannel.invokeMethod(DCMethodCall.logout);
  }

  ///Checks whether Direct Call SDK is enabled or not and returns true/false based on state
  @override
  Future<bool> isEnabled() {
    return _methodChannel
        .invokeMethod<bool>(DCMethodCall.isEnabled)
        .then<bool>((bool? value) => value ?? false);
  }

  ///Ends the active call, if any.
  @override
  Future<void> hangUpCall() {
    return _methodChannel.invokeMethod(DCMethodCall.hangUpCall);
  }
}
