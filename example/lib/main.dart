import 'dart:async';

import 'package:clevertap_signedcall_flutter/models/call_event_result.dart';
import 'package:clevertap_signedcall_flutter/models/call_events.dart';
import 'package:clevertap_signedcall_flutter/models/log_level.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/pages/dialler_page.dart';
import 'package:clevertap_signedcall_flutter_example/route_generator.dart';
import 'package:flutter/material.dart';

import 'Utils.dart';

@pragma('vm:entry-point')
void backgroundCallEventHandler(CallEventResult callEventResult) async {
  debugPrint(
      "backgroundCallEventHandler called from headless task with payload: $callEventResult");
}

@pragma('vm:entry-point')
void backgroundMissedCallActionClickedHandler(
    MissedCallActionClickResult missedCallActionClickResult) async {
  debugPrint(
      "backgroundMissedCallActionClickedHandler called from headless task with payload: $missedCallActionClickResult");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CleverTapSignedCallFlutter.shared
      .onBackgroundCallEvent(backgroundCallEventHandler);
  CleverTapSignedCallFlutter.shared.onBackgroundMissedCallActionClicked(
      backgroundMissedCallActionClickedHandler);
  runApp(const MyApp());
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
      debugPrint(
          "CleverTap:SignedCallFlutter: received callEvent stream with ${result.toString()}");
      Utils.showSnack(context, result.callEvent.toString());
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
      Navigator.pushNamed(context, DiallerPage.routeName);
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
  }
}
