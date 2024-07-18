import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';

import '../models/call_event_result.dart';
import '../models/log_level.dart';
import '../src/signedcall_handlers.dart';
import 'clevertap_signedcall_flutter_platform_interface.dart';

/// Plugin class to handle the communication b/w the flutter app and Signed Call Native SDKs(Android/iOS)
class CleverTapSignedCallFlutter {
  static final CleverTapSignedCallFlutter _shared =
      CleverTapSignedCallFlutter._internal();

  static CleverTapSignedCallFlutter get shared => _shared;

  static const sdkName = 'ctscsdkversion-flutter';
  static const sdkVersion = 00005; /// If the current version is X.X.X then pass as X0X0X

  /// This is a private named constructor.
  /// It'll be called exactly once only in this class,
  /// by the static property assignment above
  CleverTapSignedCallFlutter._internal() {
    /// Passes the CleverTap Signed Call Flutter SDK name and the current version for version tracking
    CleverTapSignedCallFlutterPlatform.instance.trackSdkVersion({'sdkName': sdkName, 'sdkVersion': sdkVersion});
  }

  /// Enables or disables debugging. If enabled, see debug messages logcat utility.
  /// Debug messages are tagged as CleverTap.
  ///
  /// [level] - an enum value from [LogLevel] class
  Future<void> setDebugLevel(LogLevel level) {
    return CleverTapSignedCallFlutterPlatform.instance.setDebugLevel(level);
  }

  ///Initializes the Signed Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]        - to get the initialization update(i.e. success/failure)
  Future<void> init(
      {required Map<String, dynamic> initProperties,
      required SignedCallInitHandler initHandler}) {
    return CleverTapSignedCallFlutterPlatform.instance
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
    return CleverTapSignedCallFlutterPlatform.instance
        .call(receiverCuid, callContext, callOptions, voIPCallHandler);
  }

  ///Returns the listener to listen the call-events stream
  Stream<CallEventResult> get callEventListener =>
      CleverTapSignedCallFlutterPlatform.instance.callEventsListener;

  ///Returns the listener to listen the call-events stream
  Stream<MissedCallActionClickResult> get missedCallActionClickListener =>
      CleverTapSignedCallFlutterPlatform.instance.missedCallActionClickListener;

  ///Disconnects the signalling socket.
  ///
  ///Call this method when all the expected/pending transactions are over
  ///and there is no use case of initiating or receiving the VoIP call.
  ///
  ///Following is the expected behaviour:
  ///- Calls can not be initiated without the signalling socket connection and
  ///  Signed Call returns an exception when call-request is attempted.
  ///- Call still be received as Signed Call uses FCM for android platform
  ///  and APNs for iOS platform as a Fallback channel.
  ///
  /// Once this method is called, SDK re-initialization is required to undo its behaviour.
  Future<void> disconnectSignallingSocket() {
    return CleverTapSignedCallFlutterPlatform.instance
        .disconnectSignallingSocket();
  }

  ///Logs out the user from the Signed Call SDK session
  Future<void> logout() {
    return CleverTapSignedCallFlutterPlatform.instance.logout();
  }

  ///Ends the active call, if any.
  Future<void> hangUpCall() {
    return CleverTapSignedCallFlutterPlatform.instance.hangUpCall();
  }

  /// Registers a callback to handle the call events when the app is in the
  /// killed state.
  ///
  /// This provided handler must be a top-level function and cannot be
  /// anonymous otherwise an [ArgumentError] will be thrown.
  void onBackgroundCallEvent(BackgroundCallEventHandler handler) {
    CleverTapSignedCallFlutterPlatform.instance.onBackgroundCallEvent(handler);
  }

  /// Registers a callback to handle the notification action clicked over missed call notification
  /// when the app is in the killed state.
  ///
  /// This provided handler must be a top-level function and cannot be
  /// anonymous otherwise an [ArgumentError] will be thrown.
  void onBackgroundMissedCallActionClicked(BackgroundMissedCallActionClickedHandler handler) {
    CleverTapSignedCallFlutterPlatform.instance.onBackgroundMissedCallActionClicked(handler);
  }
}
