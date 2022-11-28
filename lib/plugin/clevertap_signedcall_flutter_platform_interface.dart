import 'package:clevertap_signedcall_flutter/models/log_level.dart';

import '../models/call_events.dart';
import '../models/log_level.dart';
import '../models/missed_call_action_click_result.dart';
import '../src/signedcall_handlers.dart';
import 'clevertap_signedcall_flutter_method_channel.dart';

abstract class ClevertapSignedCallFlutterPlatform {
  static ClevertapSignedCallFlutterPlatform instance =
      MethodChannelClevertapSignedCallFlutter();

  /// Enables or disables debugging. If enabled, see debug messages in Android's logcat utility.
  /// Debug messages are tagged as CleverTap.
  ///
  /// [level] Can be one of the following:
  /// 1) [LogLevel.off] (disables all debugging),
  /// 2) [LogLevel.info] (default, shows minimal SDK integration related logging)
  /// 3) [LogLevel.DEBUG] (shows debug output)
  /// 4) [LogLevel.verbose] (shows verbose output)
  Future<void> setDebugLevel(LogLevel level);

  ///Initializes the Signed Call SDK
  ///
  ///[initProperties] - configuration for the initialization
  ///[initHandler]    - to handle the initialization success or failure
  Future<void> init(
      Map<String, dynamic> initProperties, SignedCallInitHandler initHandler);

  ///Initiates a VoIP call
  ///
  ///[receiverCuid]    - cuid of the person whomsoever call needs to be initiated
  ///[callContext]     - context(reason) of the call that is displayed on the call screen
  ///[callOptions]     - configuration(metadata) for a VoIP call
  ///[voIPCallHandler] - to get the initialization update(i.e. success/failure)
  Future<void> call(
      String receiverCuid,
      String callContext,
      Map<String, dynamic>? callOptions,
      SignedCallVoIPCallHandler voIPCallHandler);

  ///Broadcasts the [CallEvent] data stream to listen the real-time changes in the call-state.
  Stream<CallEvent> get callEventsListener;

  ///Broadcasts the [MissedCallActionClickResult]  data stream to listen the
  ///missed call action click events.
  Stream<MissedCallActionClickResult> get missedCallActionClickListener;

  ///Logs out the user from the Signed Call SDK session
  Future<void> logout();

  ///Ends the active call, if any.
  Future<void> hangUpCall();
}
