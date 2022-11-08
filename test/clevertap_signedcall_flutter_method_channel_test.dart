import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter_method_channel.dart';
import 'package:clevertap_signedcall_flutter/src/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  MethodChannelClevertapSignedCallFlutter platform =
      MethodChannelClevertapSignedCallFlutter();
  const MethodChannel channel = MethodChannel(channelName);

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
