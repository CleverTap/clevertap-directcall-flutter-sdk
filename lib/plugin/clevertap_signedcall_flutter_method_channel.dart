import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/src/constants.dart';
import 'package:flutter/services.dart';

import '../models/call_events.dart';
import '../models/log_level.dart';
import '../src/signed_call_logger.dart';
import '../src/signedcall_handlers.dart';
import '../src/signedcall_method_calls.dart';
import 'clevertap_signedcall_flutter_platform_interface.dart';

/// An implementation of [ClevertapSignedCallFlutterPlatform] that provides communication b/w flutter and platform.
class MethodChannelClevertapSignedCallFlutter
    extends ClevertapSignedCallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('$channelName/methods');

  Stream<CallEvent>? _callEventsListener;
  Stream<MissedCallActionClickResult>? _missedCallActionClickListener;

  late SignedCallInitHandler _initHandler;
  late SignedCallVoIPCallHandler _voIPCallHandler;

  MethodChannelClevertapSignedCallFlutter() {
    //sets the methodCallHandler to receive the method calls from native platform
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  /// Enables or disables debugging. If enabled, see debug messages in Android's logcat utility.
  /// Debug messages are tagged as CleverTap.
  ///
  /// [level] Can be one of the following:
  /// 1) [LogLevel.off] (disables all debugging),
  /// 2) [LogLevel.info] (default, shows minimal SDK integration related logging)
  /// 3) [LogLevel.DEBUG] (shows debug output)
  /// 4) [LogLevel.verbose] (shows verbose output)
  @override
  Future<void> setDebugLevel(LogLevel logLevel) {
    int logLevelValue = logLevel.value;
    SignedCallLogger.setLogLevel(logLevelValue);
    return _methodChannel
        .invokeMethod(SCMethodCall.logging, {argLogLevel: logLevelValue});
  }

  ///Broadcasts the [CallEvent] data stream to listen the real-time changes in the call-state.
  @override
  Stream<CallEvent> get callEventsListener {
    /// The event channel used to listen the data stream from the native platform.
    const callEventChannel = EventChannel('$channelName/events/call_event');
    _callEventsListener ??= callEventChannel
        .receiveBroadcastStream()
        .map((event) => CallEvent.fromString(event.toString()));
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
    SignedCallLogger.d(
        "Inside platformCallHandler: \n invoked method - '${call.method}' \n method-arguments -  ${call.arguments}");

    switch (call.method) {
      case SCMethodCall.onSignedCallDidInitialize:
        Map<dynamic, dynamic>? args = call.arguments;
        _initHandler(args?.cast<String, dynamic>());
        break;
      case SCMethodCall.onSignedCallDidVoIPCallInitiate:
        Map<dynamic, dynamic>? args = call.arguments;
        _voIPCallHandler(args?.cast<String, dynamic>());
        break;
    }
  }

  ///Initializes the Signed Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]    - to get the initialization update(i.e. success/failure)
  @override
  Future<void> init(
      Map<String, dynamic> initProperties, SignedCallInitHandler initHandler) {
    _initHandler = initHandler;
    return _methodChannel
        .invokeMethod(SCMethodCall.init, {argInitProperties: initProperties});
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
      SignedCallVoIPCallHandler voIPCallHandler) {
    _voIPCallHandler = voIPCallHandler;

    final callProperties = <String, dynamic>{};
    callProperties[keyReceiverCuid] = receiverCuid;
    callProperties[keyCallContext] = callContext;
    callProperties[keyCallOptions] = callOptions;
    return _methodChannel
        .invokeMethod(SCMethodCall.call, {argCallProperties: callProperties});
  }

  ///Logs out the user from the Signed Call SDK session
  @override
  Future<void> logout() {
    return _methodChannel.invokeMethod(SCMethodCall.logout);
  }

  ///Ends the active call, if any.
  @override
  Future<void> hangUpCall() {
    return _methodChannel.invokeMethod(SCMethodCall.hangUpCall);
  }
}
