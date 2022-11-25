import 'dart:async';

import 'package:clevertap_signedcall_flutter/models/call_events.dart';
import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/pages/registration_page.dart';
import 'package:clevertap_signedcall_flutter_example/shared_preference_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../Utils.dart';

class DiallerPage extends StatefulWidget {
  static const routeName = '/dialler';
  final String loggedInCuid;

  const DiallerPage({Key? key, required this.loggedInCuid}) : super(key: key);

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
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Dialler Screen'),
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
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                    Utils.dismissKeyboard(context);
                    Utils.askMicroPhonePermission().then((value) => {
                          initiateVoIPCall(receiverCuidController.text,
                              callContextController.text)
                        });
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
        ),
        onWillPop: () {
          return Future.value(false);
        });
  }

  void initiateVoIPCall(String? receiverCuid, String? callContext) async {
    if (receiverCuid != null && callContext != null) {
      //const callOptions = {keyInitiatorImage: null, keyReceiverImage: null};
      ClevertapSignedCallFlutter.shared.call(
          receiverCuid: receiverCuid,
          callContext: callContext,
          callOptions: null,
          voIPCallHandler: _signedCallVoIPCallHandler);
    } else {
      Utils.showSnack(
          context, 'Both Receiver cuid and context of the call are required!');
    }
  }

  void _signedCallVoIPCallHandler(SignedCallError? signedCallVoIPError) {
    if (kDebugMode) {
      print(
          "CleverTap:SignedCallFlutter: signedCallVoIPCallHandler called = ${signedCallVoIPError.toString()}");
    }

    if (signedCallVoIPError == null) {
      //Initialization is successful here
      Utils.showSnack(context, 'VoIP call is placed successfully!');
    } else {
      //Initialization is failed here
      final errorCode = signedCallVoIPError.errorCode;
      final errorMessage = signedCallVoIPError.errorMessage;
      final errorDescription = signedCallVoIPError.errorDescription;

      Utils.showSnack(
          context, 'VoIP call is failed: $errorCode = $errorMessage');
    }
  }

  //Listens to the real-time stream of call-events
  void _startObservingCallEvents() {
    _callEventSubscription =
        ClevertapSignedCallFlutter.shared.callEventListener.listen((event) {
      print(
          "CleverTap:SignedCallFlutter: received callEvent stream with ${event.toString()}");
      //Utils.showSnack(context, event.name);
      if (event == CallEvent.callInProgress) {
        //_startCallDurationMeterToEndCall();
      }
    });
  }

  //Listens to the missed call action click events
  void _startObservingMissedCallActionClickEvent() {
    _missedCallActionClickEventSubscription = ClevertapSignedCallFlutter
        .shared.missedCallActionClickListener
        .listen((result) {
      print(
          "CleverTap:SignedCallFlutter: received missedCallActionClickResult stream with ${result.toString()}");

      //Navigator.pushNamed(context, DiallerPage.routeName);
    });
  }

  //Starts a timer and hang up the active call when timer finishes
  void _startCallDurationMeterToEndCall() {
    Timer(const Duration(seconds: _callMeterDurationInSeconds), () {
      ClevertapSignedCallFlutter.shared.hangUpCall();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEventSubscription?.cancel();
    _missedCallActionClickEventSubscription?.cancel();
  }

  void logoutSession() {
    ClevertapSignedCallFlutter.shared.logout();
    SharedPreferenceManager.clearData();
    Navigator.pushNamed(context, RegistrationPage.routeName);
  }
}
