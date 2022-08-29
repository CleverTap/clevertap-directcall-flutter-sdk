import 'dart:async';

import 'package:clevertap_directcall_flutter/models/call_events.dart';
import 'package:clevertap_directcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter.dart';
import 'package:clevertap_directcall_flutter_example/pages/registration_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DiallerPage extends StatefulWidget {
  static const routeName = '/dialler';
  final ClevertapDirectcallFlutter clevertapDirectcallFlutterPlugin;
  final String loggedInCuid;

  const DiallerPage(
      {Key? key,
      required this.loggedInCuid,
      required this.clevertapDirectcallFlutterPlugin})
      : super(key: key);

  @override
  State<DiallerPage> createState() => _DiallerPageState();
}

class _DiallerPageState extends State<DiallerPage> {
  final receiverCuidController = TextEditingController();
  final callContextController = TextEditingController();

  static const int _callMeterDurationInSeconds = 15;
  late StreamSubscription<CallEvent>? _callEventSubscription;
  late StreamSubscription<MissedCallActionClickResult>?
      _missedCallActionClickEventSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  void setup() {
    _startObservingCallEvents();
    _startObservingMissedCallActionClickEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              'Welcome: ${widget.loggedInCuid}',
              // textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: receiverCuidController,
              decoration: const InputDecoration(
                hintText: 'Receiver CUID',
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: callContextController,
              decoration: const InputDecoration(
                hintText: 'Context of the call',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                initiateVoIPCall(
                    receiverCuidController.text, callContextController.text);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Initiate VOIP Call'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                logoutSession();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  void initiateVoIPCall(String? receiverCuid, String? callContext) async {
    if (receiverCuid != null && callContext != null) {
      //const callOptions = {keyInitiatorImage: null, keyReceiverImage: null};
      var isEnabled = await widget.clevertapDirectcallFlutterPlugin.isEnabled();

      //isEnabled is true when the Direct Call SDK is enabled to initiate or receive a call otherwise false
      if (isEnabled == true) {
        widget.clevertapDirectcallFlutterPlugin.call(
            receiverCuid: receiverCuid,
            callContext: callContext,
            callOptions: null,
            voIPCallHandler: _directCallVoIPCallHandler);
      }
    } else {
      const snackBar = SnackBar(
          content:
              Text('Both Receiver cuid and context of the call are required!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _directCallVoIPCallHandler(Map<String, dynamic>? directCallVoIPError) {
    if (kDebugMode) {
      print(
        "CleverTap:DirectCallFlutter: directCallVoIPCallHandler called = ${directCallVoIPError.toString()}");
    }

    if (directCallVoIPError == null) {
      //Initialization is successful here
      const snackBar =
          SnackBar(content: Text('VoIP call is placed successfully!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      //Initialization is failed here
      final errorCode = directCallVoIPError[keyErrorCode];
      final errorMessage = directCallVoIPError[keyErrorMessage];

      final snackBar = SnackBar(
          content: Text('VoIP call is failed: $errorCode = $errorMessage'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //Listens to the real-time stream of call-events
  void _startObservingCallEvents() {
    _callEventSubscription = widget
        .clevertapDirectcallFlutterPlugin.callEventListener
        .listen((event) {
      print(
          "CleverTap:DirectCallFlutter: received callEvent stream with ${event.toString()}");
      if (event == CallEvent.answered) {
        _startCallDurationMeterToEndCall();
      }
    });
  }

  //Listens to the missed call action click events
  void _startObservingMissedCallActionClickEvent() {
    _missedCallActionClickEventSubscription = widget
        .clevertapDirectcallFlutterPlugin.missedCallActionClickListener
        .listen((result) {
      print(
          "CleverTap:DirectCallFlutter: received missedCallActionClickResult stream with ${result.toString()}");
    });
  }

  //Starts a timer and hang up the active call when timer finishes
  void _startCallDurationMeterToEndCall() {
    Timer(const Duration(seconds: _callMeterDurationInSeconds), () {
      widget.clevertapDirectcallFlutterPlugin.hangUpCall();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEventSubscription?.cancel();
    _missedCallActionClickEventSubscription?.cancel();
  }

  void logoutSession() {
    widget.clevertapDirectcallFlutterPlugin.logout();
    Navigator.pushNamed(context, RegistrationPage.routeName);
  }
}
