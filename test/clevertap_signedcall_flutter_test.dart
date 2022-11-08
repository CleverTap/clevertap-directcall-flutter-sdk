
import 'package:clevertap_signedcall_flutter/models/call_events.dart';
import 'package:clevertap_signedcall_flutter/models/log_level.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter_method_channel.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter_platform_interface.dart';
import 'package:clevertap_signedcall_flutter/src/signedcall_handlers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClevertapDirectcallFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ClevertapSignedCallFlutterPlatform {
  @override
  Future<void> call(
      String receiverCuid,
      String callContext,
      Map<String, dynamic>? callOptions,
      SignedCallVoIPCallHandler voIPCallHandler) {
    // TODO: implement call
    throw UnimplementedError();
  }

  @override
  // TODO: implement callEventsListener
  Stream<CallEvent> get callEventsListener => throw UnimplementedError();

  @override
  Future<void> hangUpCall() {
    // TODO: implement hangUpCall
    throw UnimplementedError();
  }

  @override
  Future<void> init(
      Map<String, dynamic> initProperties, SignedCallInitHandler initHandler) {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override
  Future<bool> isEnabled() {
    // TODO: implement isEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  // TODO: implement missedCallActionClickListener
  Stream<MissedCallActionClickResult> get missedCallActionClickListener =>
      throw UnimplementedError();

  @override
  Future<void> setDebugLevel(LogLevel level) {
    // TODO: implement setDebugLevel
    throw UnimplementedError();
  }
}

void main() {
  final ClevertapSignedCallFlutterPlatform initialPlatform =
      ClevertapSignedCallFlutterPlatform.instance;

  test('$MethodChannelClevertapSignedCallFlutter is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelClevertapSignedCallFlutter>());
  });
}
