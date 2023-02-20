import 'dart:async';

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
                    CleverTapSignedCallFlutter.shared.disconnectSignallingSocket();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                  child: const Text('Disconnect Signalling Socket'),
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
      CleverTapSignedCallFlutter.shared.call(
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
    debugPrint(
        "CleverTap:SignedCallFlutter: signedCallVoIPCallHandler called = ${signedCallVoIPError.toString()}");
    if (signedCallVoIPError == null) {
      //Initialization is successful here
      Utils.showSnack(context, 'VoIP call is placed successfully!');
    } else {
      //Initialization is failed here
      final errorCode = signedCallVoIPError.errorCode;
      final errorMessage = signedCallVoIPError.errorMessage;
      final errorDescription = signedCallVoIPError.errorDescription;

      Utils.showSnack(context, 'VoIP call failed: $errorCode = $errorMessage');
    }
  }

  //Starts a timer and hang up the ongoing call when the timer finishes
  void _startCallDurationMeterToEndCall() {
    Timer(const Duration(seconds: _callMeterDurationInSeconds), () {
      CleverTapSignedCallFlutter.shared.hangUpCall();
    });
  }

  void logoutSession() {
    CleverTapSignedCallFlutter.shared.logout();
    SharedPreferenceManager.clearData();
    Navigator.pushNamed(context, RegistrationPage.routeName);
  }
}
