import 'dart:ui';

import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/src/signed_call_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/call_event_result.dart';
import 'constants.dart';

// This is the entrypoint for the background isolate. Since we can only enter
// an isolate once, we setup a MethodChannel to listen for method invocations
// from the native portion of the plugin. This allows for the plugin to perform
// any necessary processing in Dart (e.g., populating a custom object) before
// invoking the provided callback.
@pragma('vm:entry-point')
void backgroundCallbackDispatcher() {
  // Initialize state which is necessary for the MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    '$channelName/background_isolate_channel',
  );

  // This is where we handle background events from the native portion of the plugin.
  channel.setMethodCallHandler((
    MethodCall call,
  ) async {
    SignedCallLogger.d(
        "callbackDispatcher called with arguments: ${call.arguments}");

    if (call.method == 'onBackgroundCallEvent' ||
        call.method == 'onBackgroundMissedCallActionClicked') {
      final CallbackHandle handle =
          CallbackHandle.fromRawHandle(call.arguments['userCallbackHandle']);

      // PluginUtilities.getCallbackFromHandle performs a lookup based on the
      // callback handle and returns a tear-off of the original callback.
      Function? callback = PluginUtilities.getCallbackFromHandle(handle);

      try {
        if (call.method == 'onBackgroundCallEvent') {
          await callback!(CallEventResult.fromMap(call.arguments['payload']));
        } else {
          await callback!(
              MissedCallActionClickResult.fromMap(call.arguments['payload']));
        }
      } catch (e) {
        SignedCallLogger.d('An error occurred in your callbackDispatcher: $e');
      }
    } else {
      throw UnimplementedError('${call.method} has not been implemented');
    }
  });

  // Once we've finished initializing the callbackDispatcher, let the native portion of the plugin
  // know that it can start the callback invocation.
  channel.invokeMethod<void>('SCBackgroundCallbackDispatcher#initialized');
}
