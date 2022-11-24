import 'dart:io';

import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/Utils.dart';
import 'package:clevertap_signedcall_flutter_example/constants.dart';
import 'package:clevertap_signedcall_flutter_example/pages/dialler_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../shared_preference_manager.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = '/registration';
  final String title;

  const RegistrationPage({Key? key, required this.title}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _userCuid = '';
  final cuidController = TextEditingController();
  bool isLoadingVisible = false;

  @override
  void initState() {
    super.initState();
    initDCSDKIfCuIDSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Signed Call'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'USER-REGISTRATION',
              // textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/clevertap-logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cuidController,
              decoration: const InputDecoration(
                hintText: 'Enter CUID',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                initSignedCallSdk(cuidController.text);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Register and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  // Initializes the Signed Call SDK
  void initSignedCallSdk(String inputCuid) {
    showLoading();

    _userCuid = inputCuid;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      const callScreenBranding = {
        keyBgColor: "#000000",
        keyFontColor: "#ffffff",
        keyLogoUrl:
            "https://res.cloudinary.com/dsakrbtd6/image/upload/v1642409353/ct-logo_mkicxg.png",
        keyButtonTheme: "light"
      };

      const missedCallActionsMap = {
        "1": "Call me back",
        "2": "Start Chat",
        "3": "Not Interested"
      };

      final Map<String, dynamic> initProperties = {
        keyAccountId: scAccountId,
        keyApiKey: scApiKey,
        keyCuid: _userCuid,
        keyOverrideDefaultBranding: callScreenBranding
      };

      ///Android Platform fields
      if (Platform.isAndroid) {
        initProperties[keyAllowPersistSocketConnection] = true;
        initProperties[keyEnableReadPhoneState] = true;
        initProperties[keyMissedCallActions] = missedCallActionsMap;
      }

      ///iOS Platform fields
      if (Platform.isIOS) {
        initProperties[keyProduction] = false;
      }

      ClevertapSignedCallFlutter.shared.init(
          initProperties: initProperties, initHandler: _signedCallInitHandler);
    } on PlatformException {
      Utils.showSnack(context, 'PlatformException occurs!');
    }
  }

  Future<void> _signedCallInitHandler(
      SignedCallError? signedCallInitError) async {
    if (kDebugMode) {
      print(
          "CleverTap:SignedCallFlutter: signedCallInitHandler called = ${signedCallInitError.toString()}");
    }
    if (signedCallInitError == null) {
      //Initialization is successful here
      const snackBar = SnackBar(content: Text('Signed Call SDK Initialized!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      processNext();
    } else {
      //Initialization is failed here
      final errorCode = signedCallInitError.errorCode;
      final errorMessage = signedCallInitError.errorMessage;
      final errorDescription = signedCallInitError.errorDescription;

      hideLoading();
      Utils.showSnack(context, 'SC Init failed: $errorCode = $errorMessage');
    }
  }

  void processNext() {
    //save cuid in a local session
    SharedPreferenceManager.saveLoggedInCuid(_userCuid);

    //Navigate the user to the Dialler Page
    Navigator.pushNamed(context, DiallerPage.routeName,
        arguments: {keyLoggedInCuid: _userCuid});
  }

  void initDCSDKIfCuIDSignedIn() {
    SharedPreferenceManager.getLoggedInCuid().then((loggedInCuid) {
      setState(() {
        if (loggedInCuid != null) {
          _userCuid = loggedInCuid;
          initSignedCallSdk(loggedInCuid);
        }
      });
    });
  }

  void showLoading() {
    isLoadingVisible = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void hideLoading() {
    if (isLoadingVisible) {
      Navigator.pop(context);
      isLoadingVisible = false;
    }
  }
}
