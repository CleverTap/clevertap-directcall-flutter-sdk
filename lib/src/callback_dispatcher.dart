// This is the entrypoint for the background isolate. Since we can only enter
// an isolate once, we setup a MethodChannel to listen for method invocations
// from the native portion of the plugin. This allows for the plugin to perform
// any necessary processing in Dart (e.g., populating a custom object) before
// invoking the provided callback.
import 'dart:ui';

import 'package:clevertap_signedcall_flutter/models/call_status_details.dart';
import 'package:clevertap_signedcall_flutter/src/signed_call_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// This is the entrypoint for the background isolate. Since we can only enter
// an isolate once, we setup a MethodChannel to listen for method invocations
// from the native portion of the plugin. This allows for the plugin to perform
// any necessary processing in Dart (e.g., populating a custom object) before
// invoking the provided callback.
@pragma('vm:entry-point')
void callbackDispatcher() {
  // Initialize state necessary for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel _channel = MethodChannel(
    'clevertap_plugin/background_isolate_channel',
  );

  // This is where we handle background events from the native portion of the plugin.
  _channel.setMethodCallHandler((MethodCall call,) async {
    print("callbackDispatcher called!");

    print("callbackDispatcher called!" + call.arguments.toString());

    if (call.method == 'onCallEventInKilledState') {
      print("callbackDispatcher called!" + "0");

      final CallbackHandle handle =
      CallbackHandle.fromRawHandle(call.arguments['userCallbackHandle']);
      print("callbackDispatcher called!" + "1");

      // PluginUtilities.getCallbackFromHandle performs a lookup based on the
      // callback handle and returns a tear-off of the original callback.
      Function? callback = PluginUtilities.getCallbackFromHandle(handle);
      print("callbackDispatcher called!" + "2");

      try {
        await callback!(SCCallStatusDetails.fromMap(call.arguments['payload']));
      } catch (e) {
        SignedCallLogger.d('An error occurred in your callbackDispatcher: $e');
        print("callbackDispatcher called!" + " 3:  $e");

      }
      print("callbackDispatcher called!" + "4");

    } else {
      throw UnimplementedError('${call.method} has not been implemented');
    }
  });

  // Once we've finished initializing the callbackDispatcher, let the native portion of the plugin
  // know that it can start the callback invocation.
  _channel.invokeMethod<void>('CleverTapCallbackDispatcher#initialized');
}