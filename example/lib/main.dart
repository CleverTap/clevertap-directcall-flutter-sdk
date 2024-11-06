import 'dart:async';

import 'package:clevertap_signedcall_flutter/models/call_details.dart';
import 'package:clevertap_signedcall_flutter/models/call_event_result.dart';
import 'package:clevertap_signedcall_flutter/models/call_events.dart';
import 'package:clevertap_signedcall_flutter/models/call_state.dart';
import 'package:clevertap_signedcall_flutter/models/log_level.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/pages/dialler_page.dart';
import 'package:clevertap_signedcall_flutter_example/route_generator.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';

@pragma('vm:entry-point')
void backgroundCallEventHandler(CallEventResult result) async {
  debugPrint(
      "backgroundCallEventHandler called from headless task with payload1: $result");
  Utils.showToast("${result.callEvent} is called!" );

  getCallState().then((value) => {
    debugPrint(
        "CleverTap:SignedCallFlutter: CallState in killed state is: => $value")
  });
}

@pragma('vm:entry-point')
void backgroundMissedCallActionClickedHandler(
    MissedCallActionClickResult result) async {
  debugPrint(
      "backgroundMissedCallActionClickedHandler called from headless task with payload: $result");
  Utils.showToast("${result.action.actionLabel} is clicked!" );
}

@pragma('vm:entry-point')
void backgroundFCMNotificationClickedHandler(
    CallDetails callDetails) async {
  debugPrint("backgroundFCMNotificationClickedHandler called from headless task with payload ${callDetails.toString()}");
  Utils.showToast("FCM Notification is Clicked!,  ${callDetails.callId}" );
}

@pragma('vm:entry-point')
void backgroundFCMNotificationCancelCTAClickedHandler(
    CallDetails callDetails) async {
  debugPrint("backgroundFCMNotificationCancelCTAClickedHandler called from headless task with payload ${callDetails.toString()}");
  Utils.showToast("FCM Notification Cancel CTA is Clicked!,  ${callDetails.callId}" );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CleverTapSignedCallFlutter.shared
      .onBackgroundCallEvent(backgroundCallEventHandler);
  CleverTapSignedCallFlutter.shared.onBackgroundMissedCallActionClicked(
      backgroundMissedCallActionClickedHandler);
  CleverTapSignedCallFlutter.shared.onBackgroundFCMNotificationClicked(
      backgroundFCMNotificationClickedHandler);
  CleverTapSignedCallFlutter.shared.onBackgroundFCMNotificationCancelCTAClicked(
      backgroundFCMNotificationCancelCTAClickedHandler);
  runApp(const MyApp());
}

Future<SCCallState?> getCallState() async {
  SCCallState? callState =
  await CleverTapSignedCallFlutter.shared.getCallState();
  return callState;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<CallEventResult>? _callEventSubscription;
  late StreamSubscription<MissedCallActionClickResult>?
      _missedCallActionClickEventSubscription;
  late StreamSubscription<CallDetails>? _fcmNotificationClickEventSubscription;
  late StreamSubscription<CallDetails>? _fcmNotificationCancelCTAClickEventSubscription;
  static const int _callMeterDurationInSeconds = 15;

  @override
  void initState() {
    super.initState();

    //Enables the verbose debugging in Signed Call Plugin
    CleverTapSignedCallFlutter.shared.setDebugLevel(LogLevel.verbose);
    setup();
  }

  void setup() {
    _startObservingCallEvents();
    _startObservingMissedCallActionClickEvent();
    _startObservingFCMNotificationClickEvent();
    _startObservingFCMNotificationCancelCTAClickEvent();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  //Listens to the real-time stream of call-events
  void _startObservingCallEvents() {
    _callEventSubscription =
        CleverTapSignedCallFlutter.shared.callEventListener.listen((result) {
      getCallState().then((value) => {
            debugPrint(
                "CleverTap:SignedCallFlutter: Current CallState is: => $value")
          });

      debugPrint(
          "CleverTap:SignedCallFlutter: received callEvent stream with ${result.toString()}");
      var callDetails = result.callDetails;
      var callId = callDetails.callId;
      var channel = callDetails.channel;

      Utils.showToast("${callId?.substring(0, 3)}, ${channel.toString()}, ${result.callEvent.toString()} is called!");
      if (result.callEvent == CallEvent.callInProgress) {
        //_startCallDurationMeterToEndCall();
      }
    });
  }

  //Listens to the missed call action click events
  void _startObservingMissedCallActionClickEvent() {
    _missedCallActionClickEventSubscription = CleverTapSignedCallFlutter
        .shared.missedCallActionClickListener
        .listen((result) {
      debugPrint(
          "CleverTap:SignedCallFlutter: received missedCallActionClickResult stream with ${result.toString()}");
      Utils.showToast("${result.action.actionLabel} is clicked!" );

      Navigator.pushNamed(context, DiallerPage.routeName);
    });
  }

  //Listens to the missed call action click events
  void _startObservingFCMNotificationClickEvent() {
    _fcmNotificationClickEventSubscription = CleverTapSignedCallFlutter
        .shared.fcmNotificationClickListener
        .listen((callDetails) {
      debugPrint(
          "CleverTap:SignedCallFlutter: received fcmNotificationClicked stream with ${callDetails.toString()}");
      Utils.showToast("FCM Notification is Clicked!,  ${callDetails.callId}" );
    });
  }

  //Listens to the missed call action click events
  void _startObservingFCMNotificationCancelCTAClickEvent() {
    _fcmNotificationCancelCTAClickEventSubscription = CleverTapSignedCallFlutter
        .shared.fcmNotificationCancelCTAClickListener
        .listen((callDetails) {
      debugPrint(
          "CleverTap:SignedCallFlutter: received fcmNotificationCancelCTAClicked stream with ${callDetails.toString()}");
      Utils.showToast("FCM Notification Cancel CTA is Clicked!,  ${callDetails.callId}" );
    });
  }

  //Starts a timer and hang up the ongoing call when the timer finishes
  void _startCallDurationMeterToEndCall() {
    Timer(const Duration(seconds: _callMeterDurationInSeconds), () {
      CleverTapSignedCallFlutter.shared.hangUpCall();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEventSubscription?.cancel();
    _missedCallActionClickEventSubscription?.cancel();
    _fcmNotificationClickEventSubscription?.cancel();
    _fcmNotificationCancelCTAClickEventSubscription?.cancel();
  }
}
