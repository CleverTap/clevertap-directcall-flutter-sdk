import 'package:clevertap_directcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_directcall_flutter/src/constants.dart';
import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';
import 'package:clevertap_directcall_flutter/src/directcall_method_calls.dart';
import 'package:clevertap_directcall_flutter/src/utils.dart';
import 'package:flutter/services.dart';

import 'clevertap_directcall_flutter_platform_interface.dart';
import 'models/call_events.dart';

/// An implementation of [ClevertapDirectcallFlutterPlatform] that uses method channels.
class MethodChannelClevertapDirectcallFlutter
    extends ClevertapDirectcallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('$channelName/methods');

  Stream<CallEvent>? _callEventsListener;
  Stream<MissedCallActionClickResult>? _missedCallActionClickListener;

  late DirectCallInitHandler _initHandler;
  late DirectCallVoIPCallHandler _voIPCallHandler;

  MethodChannelClevertapDirectcallFlutter() {
    //sets the methodCallHandler to receive the method calls from native platform
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  ///Broadcasts the [CallEvent] data stream to listen the real-time changes in the call-state.
  @override
  Stream<CallEvent> get callEventsListener {
    /// The event channel used to listen the data stream from the native platform.
    const callEventChannel = EventChannel('$channelName/events/call_event');
    _callEventsListener ??= callEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => Utils.parseCallEvent(event));
    return _callEventsListener!;
  }

  ///Broadcasts the [MissedCallActionClickResult]  data stream to listen the
  ///missed call action click events.
  @override
  Stream<MissedCallActionClickResult> get missedCallActionClickListener {
    const missedCallActionClickEventChannel =
        EventChannel('$channelName/events/missed_call_action_click');
    _missedCallActionClickListener ??= missedCallActionClickEventChannel
        .receiveBroadcastStream()
        .map((dynamic missedCallActionClickResult) =>
            MissedCallActionClickResult.fromMap(missedCallActionClickResult));
    return _missedCallActionClickListener!;
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
  ///[receiverCuid]    - cuid of the person whomsoever call needs to be initiated
  ///[callContext]     - context(reason) of the call that is displayed on the call screen
  ///[callOptions]     - configuration(metadata) for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  @override
  Future<void> call(
      String receiverCuid,
      String callContext,
      Map<String, dynamic>? callOptions,
      DirectCallVoIPCallHandler voIPCallHandler) {
    _voIPCallHandler = voIPCallHandler;

    final callProperties = <String, dynamic>{};
    callProperties[keyReceiverCuid] = receiverCuid;
    callProperties[keyCallContext] = callContext;
    callProperties[keyCallOptions] = callOptions;
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
