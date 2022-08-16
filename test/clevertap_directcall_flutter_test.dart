import 'package:flutter_test/flutter_test.dart';
import 'package:clevertap_directcall_flutter/clevertap_directcall_flutter.dart';
import 'package:clevertap_directcall_flutter/clevertap_directcall_flutter_platform_interface.dart';
import 'package:clevertap_directcall_flutter/clevertap_directcall_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockClevertapDirectcallFlutterPlatform 
    with MockPlatformInterfaceMixin
    implements ClevertapDirectcallFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ClevertapDirectcallFlutterPlatform initialPlatform = ClevertapDirectcallFlutterPlatform.instance;

  test('$MethodChannelClevertapDirectcallFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelClevertapDirectcallFlutter>());
  });

  test('getPlatformVersion', () async {
    ClevertapDirectcallFlutter clevertapDirectcallFlutterPlugin = ClevertapDirectcallFlutter();
    MockClevertapDirectcallFlutterPlatform fakePlatform = MockClevertapDirectcallFlutterPlatform();
    ClevertapDirectcallFlutterPlatform.instance = fakePlatform;
  
    expect(await clevertapDirectcallFlutterPlugin.getPlatformVersion(), '42');
  });
}
