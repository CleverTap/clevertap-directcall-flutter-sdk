import 'package:clevertap_signedcall_flutter/models/call_details.dart';
import 'package:clevertap_signedcall_flutter/models/call_event_result.dart';
import 'package:clevertap_signedcall_flutter/models/call_state.dart';
import 'package:clevertap_signedcall_flutter/models/log_level.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter_method_channel.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter_platform_interface.dart';
import 'package:clevertap_signedcall_flutter/src/signedcall_handlers.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCleverTapDirectcallFlutterPlatform
    implements CleverTapSignedCallFlutterPlatform {
  @override
  Future<void> trackSdkVersion(Map<String, dynamic> versionTrackingMap) {
    throw UnimplementedError();
  }

  @override
  Future<void> call(
      String receiverCuid,
      String callContext,
      Map<String, dynamic>? callOptions,
      SignedCallVoIPCallHandler voIPCallHandler) {
    throw UnimplementedError();
  }

  @override
  Stream<CallEventResult> get callEventsListener => throw UnimplementedError();

  @override
  Future<void> hangUpCall() {
    throw UnimplementedError();
  }

  @override
  Future<void> init(
      Map<String, dynamic> initProperties, SignedCallInitHandler initHandler) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Stream<MissedCallActionClickResult> get missedCallActionClickListener =>
      throw UnimplementedError();

  @override
  Future<void> setDebugLevel(LogLevel level) {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnectSignallingSocket() {
    throw UnimplementedError();
  }

  @override
  void onBackgroundCallEvent(BackgroundCallEventHandler handler) {
    throw UnimplementedError();
  }

  @override
  void onBackgroundMissedCallActionClicked(BackgroundMissedCallActionClickedHandler handler) {
    throw UnimplementedError();
  }

  @override
  void onBackgroundFCMNotificationClicked(BackgroundFCMNotificationClickedHandler handler) {
    throw UnimplementedError();
  }

  @override
  void onBackgroundFCMNotificationCancelCTAClicked(BackgroundFCMNotificationClickedHandler handler) {
    throw UnimplementedError();
  }

  @override
  Future<bool> getBackToCall() {
    // TODO: implement getBackToCall
    throw UnimplementedError();
  }

  @override
  Future<SCCallState?> getCallState() {
    // TODO: implement getCallState
    throw UnimplementedError();
  }

  @override
  Stream<CallDetails> get fcmNotificationCancelCTAClickListener => throw UnimplementedError();

  @override
  Stream<CallDetails> get fcmNotificationClickListener => throw UnimplementedError();
}

void main() {
  final CleverTapSignedCallFlutterPlatform initialPlatform =
      CleverTapSignedCallFlutterPlatform.instance;

  test('$MethodChannelCleverTapSignedCallFlutter is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelCleverTapSignedCallFlutter>());
  });
}
