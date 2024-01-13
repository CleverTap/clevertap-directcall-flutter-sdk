import 'dart:async';

import 'package:clevertap_signedcall_flutter/models/call_events.dart';
import 'package:clevertap_signedcall_flutter/models/call_status_details.dart';
import 'package:clevertap_signedcall_flutter/models/log_level.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/route_generator.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
void onKilledStateNotificationClickedHandler(SCCallStatusDetails callStatusDetails) async {
  debugPrint("onKilledStateNotificationClickedHandler called from headless task!");
  debugPrint("CallStateListener is called2: $callStatusDetails");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CleverTapSignedCallFlutter.shared.onCallEventInKilledState(
      onKilledStateNotificationClickedHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<SCCallStatusDetails>? _callEventSubscription;
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
        CleverTapSignedCallFlutter.shared.callEventListener.listen((event) {

          debugPrint("CallStateListener is called1: $event");
      //Utils.showSnack(context, event.name);
      if (event == CallEvent.callIsPlaced) {

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
      //Navigator.pushNamed(context, <SomePage.routeName>);
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
