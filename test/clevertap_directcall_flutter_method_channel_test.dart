import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter_method_channel.dart';

void main() {
  MethodChannelClevertapDirectcallFlutter platform = MethodChannelClevertapDirectcallFlutter();
  const MethodChannel channel = MethodChannel('clevertap_directcall_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}