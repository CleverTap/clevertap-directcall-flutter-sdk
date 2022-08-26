import 'package:clevertap_directcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_directcall_flutter/src/directcall_handlers.dart';

import 'clevertap_directcall_flutter_platform_interface.dart';
import 'models/call_events.dart';

/// Plugin class to handle the communication b/w the flutter app and Direct Call Native SDKs(Android/iOS)
class ClevertapDirectcallFlutter {
  ///Initializes the Direct Call SDK
  ///
  ///[initProperties] - configuration for initialization
  ///[initHandler]        - to get the initialization update(i.e. success/failure)
  Future<void> init(
      {required Map<String, dynamic> initProperties,
      required DirectCallInitHandler initHandler}) {
    return ClevertapDirectcallFlutterPlatform.instance
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
      required DirectCallVoIPCallHandler voIPCallHandler}) {
    return ClevertapDirectcallFlutterPlatform.instance
        .call(receiverCuid, callContext, callOptions, voIPCallHandler);
  }

  ///Returns the listener to listen the call-events stream
  Stream<CallEvent> get callEventListener =>
      ClevertapDirectcallFlutterPlatform.instance.callEventsListener;

  ///Returns the listener to listen the call-events stream
  Stream<MissedCallActionClickResult> get missedCallActionClickListener =>
      ClevertapDirectcallFlutterPlatform.instance.missedCallActionClickListener;

  ///Logs out the user from the Direct Call SDK session
  Future<void> logout() {
    return ClevertapDirectcallFlutterPlatform.instance.logout();
  }

  ///Logs out the user from the Direct Call SDK session
  Future<bool?> isEnabled() {
    return ClevertapDirectcallFlutterPlatform.instance.isEnabled();
  }

  ///Ends the active call, if any.
  Future<void> hangUpCall() {
    return ClevertapDirectcallFlutterPlatform.instance.hangUpCall();
  }
}
