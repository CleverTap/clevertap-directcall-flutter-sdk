import 'dart:ui';

import 'package:clevertap_signedcall_flutter/models/call_state.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/src/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/call_event_result.dart';
import '../models/call_events.dart';
import '../models/log_level.dart';
import '../models/signed_call_error.dart';
import '../models/swipe_off_behaviour.dart';
import '../src/callback_dispatcher.dart';
import '../src/handler_info.dart';
import '../src/signed_call_logger.dart';
import '../src/signedcall_handlers.dart';
import '../src/signedcall_method_calls.dart';
import 'clevertap_signedcall_flutter_platform_interface.dart';

/// An implementation of [CleverTapSignedCallFlutterPlatform] that provides communication b/w flutter and platform.
class MethodChannelCleverTapSignedCallFlutter
    extends CleverTapSignedCallFlutterPlatform {
  /// The method channel used to interact with the native platform.
  final _methodChannel = const MethodChannel('$channelName/methods');

  Stream<CallEventResult>? _callEventsListener;
  Stream<MissedCallActionClickResult>? _missedCallActionClickListener;

  late SignedCallInitHandler _initHandler;
  late SignedCallVoIPCallHandler _voIPCallHandler;

  final Map<Type, HandlerInfo> _registeredHandlers = {};

  MethodChannelCleverTapSignedCallFlutter() {
    //sets the methodCallHandler to receive the method calls from native platform
    _methodChannel.setMethodCallHandler(_platformCallHandler);
  }

  /// Passes the current SDK version for version tracking
  @override
  Future<void> trackSdkVersion(Map<String, dynamic> versionTrackingMap) {
    return _methodChannel
        .invokeMethod(SCMethodCall.trackSdkVersion, versionTrackingMap);
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

  @override
  void onBackgroundCallEvent(BackgroundCallEventHandler handler) {
    _registerEventHandler(handler, "registerBackgroundCallEventHandler");
  }

  @override
  void onBackgroundMissedCallActionClicked(BackgroundMissedCallActionClickedHandler handler) {
    _registerEventHandler(handler, "registerBackgroundMissedCallActionClickedHandler");
  }

  ///Broadcasts the [CallEvent] data stream to listen the real-time changes in the call-state.
  @override
  Stream<CallEventResult> get callEventsListener {
    /// The event channel used to listen the data stream from the native platform.
    const callEventChannel = EventChannel('$channelName/events/call_event');
    _callEventsListener ??= callEventChannel
        .receiveBroadcastStream()
        .map((dynamic callStatusDetails) => CallEventResult.fromMap(callStatusDetails));
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
        .map((dynamic missedCallActionClickResult) {
      notifyAck(SCMethodCall.ackMissedCallActionClickedStream);
      return MissedCallActionClickResult.fromMap(missedCallActionClickResult);
    });
    return _missedCallActionClickListener!;
  }

  ///Handles the Platform-specific method-calls
  Future _platformCallHandler(MethodCall call) async {
    SignedCallLogger.d(
        "Inside platformCallHandler: \n invoked method - '${call.method}' \n method-arguments -  ${call.arguments}");
    Map<dynamic, dynamic>? args = call.arguments;

    switch (call.method) {
      case SCMethodCall.onSignedCallDidInitialize:
        SignedCallError? initError;
        if (args != null) {
          initError = SignedCallError.fromMap(args);
        }
        _initHandler(initError);
        break;
      case SCMethodCall.onSignedCallDidVoIPCallInitiate:
        SignedCallError? voipCallError;
        if (args != null) {
          voipCallError = SignedCallError.fromMap(args);
        }
        _voIPCallHandler(voipCallError);
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
    final convertedInitProperties = initProperties.map((key, value) {
      if (value is SCSwipeOffBehaviour) {
        return MapEntry(key, value.toValue());
      }
      return MapEntry(key, value);
    });
    return _methodChannel.invokeMethod(
        SCMethodCall.init, {argInitProperties: convertedInitProperties});
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

  ///Disconnects the signalling socket
  @override
  Future<void> disconnectSignallingSocket() {
    return _methodChannel.invokeMethod(SCMethodCall.disconnectSignallingSocket);
  }

  /// Attempts to return to the active call screen.
  /// It checks if there is an active call and if the client is on a VoIP call.
  /// If the both conditions are met, it launches the call screen
  @override
  Future<bool> getBackToCall() async {
    var result = await _methodChannel.invokeMethod(SCMethodCall.getBackToCall);
    return result;
  }

  /// Retrieves the current call state.
  @override
  Future<SCCallState?> getCallState() async {
    var result = await _methodChannel.invokeMethod(SCMethodCall.getCallState);
    return SCCallState.fromString(result);
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

  void _registerEventHandler<T extends Function>(
      T handler, String methodName) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    Type handlerType = T;

    if (!_registeredHandlers.containsKey(handlerType) ||
        !_registeredHandlers[handlerType]!.initialized) {
      _registeredHandlers[handlerType] =
          HandlerInfo(handler: handler, initialized: true);

      final CallbackHandle pluginCallbackHandle =
          PluginUtilities.getCallbackHandle(backgroundCallbackDispatcher)!;
      final CallbackHandle? userCallbackHandle =
          PluginUtilities.getCallbackHandle(handler);

      // Callback handler should be a top-level or static function, independent of any inner scopes.
      if (userCallbackHandle == null) {
        throw ArgumentError(
            'Failed to setup background handle. `$handlerType` must be a TOP LEVEL or a STATIC method');
      }

      await _methodChannel.invokeMapMethod(methodName, {
        'pluginCallbackHandle': pluginCallbackHandle.toRawHandle(),
        'userCallbackHandle': userCallbackHandle.toRawHandle(),
      });
    }
  }

  void notifyAck(String ackName) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _methodChannel.invokeMethod(ackName);
    }
  }
}