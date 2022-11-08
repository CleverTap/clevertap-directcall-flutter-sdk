import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';

import '../models/call_events.dart';
import '../models/log_level.dart';
import '../src/signedcall_handlers.dart';
import 'clevertap_signedcall_flutter_platform_interface.dart';

/// Plugin class to handle the communication b/w the flutter app and Signed Call Native SDKs(Android/iOS)
class ClevertapSignedCallFlutter {
  /// Enables or disables debugging. If enabled, see debug messages logcat utility.
  /// Debug messages are tagged as CleverTap.
  ///
  /// [level] - an enum value from [LogLevel] class
  static Future<void> setDebugLevel(LogLevel level) {
    return ClevertapSignedCallFlutterPlatform.instance.setDebugLevel(level);
  }

  ///Initializes the Signed Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]        - to get the initialization update(i.e. success/failure)
  Future<void> init(
      {required Map<String, dynamic> initProperties,
      required SignedCallInitHandler initHandler}) {
    return ClevertapSignedCallFlutterPlatform.instance
        .init(initProperties, initHandler);
  }

  ///Initiates a VoIP call
  ///
  ///[receiverCuid]    - cuid of the person whomsoever call needs to be initiated
  ///[callContext]     - context(reason) of the call that is displayed on the call screen
  ///[callOptions]     - configuration(metadata) for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  Future<void> call(
      {required String receiverCuid,
      required String callContext,
      Map<String, dynamic>? callOptions,
      required SignedCallVoIPCallHandler voIPCallHandler}) {
    return ClevertapSignedCallFlutterPlatform.instance
        .call(receiverCuid, callContext, callOptions, voIPCallHandler);
  }

  ///Returns the listener to listen the call-events stream
  Stream<CallEvent> get callEventListener =>
      ClevertapSignedCallFlutterPlatform.instance.callEventsListener;

  ///Returns the listener to listen the call-events stream
  Stream<MissedCallActionClickResult> get missedCallActionClickListener =>
      ClevertapSignedCallFlutterPlatform.instance.missedCallActionClickListener;

  ///Logs out the user from the Signed Call SDK session
  Future<void> logout() {
    return ClevertapSignedCallFlutterPlatform.instance.logout();
  }

  ///Logs out the user from the Signed Call SDK session
  Future<bool?> isEnabled() {
    return ClevertapSignedCallFlutterPlatform.instance.isEnabled();
  }

  ///Ends the active call, if any.
  Future<void> hangUpCall() {
    return ClevertapSignedCallFlutterPlatform.instance.hangUpCall();
  }
}
