import 'package:clevertap_directcall_flutter/models/call_events.dart';
import 'package:clevertap_directcall_flutter/models/log_level.dart';
import 'package:clevertap_directcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter_method_channel.dart';
import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter_platform_interface.dart';
import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClevertapDirectcallFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ClevertapDirectcallFlutterPlatform {
  @override
  Future<void> call(
      String receiverCuid,
      String callContext,
      Map<String, dynamic>? callOptions,
      DirectCallVoIPCallHandler voIPCallHandler) {
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
      Map<String, dynamic> initProperties, DirectCallInitHandler initHandler) {
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
  final ClevertapDirectcallFlutterPlatform initialPlatform =
      ClevertapDirectcallFlutterPlatform.instance;

  test('$MethodChannelClevertapDirectcallFlutter is the default instance', () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelClevertapDirectcallFlutter>());
  });
}
