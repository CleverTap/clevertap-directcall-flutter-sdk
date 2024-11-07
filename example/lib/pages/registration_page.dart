import 'dart:io';

import 'package:clevertap_plugin/clevertap_plugin.dart';
import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';
import 'package:clevertap_signedcall_flutter/models/swipe_off_behaviour.dart';
import 'package:clevertap_signedcall_flutter/models/fcm_processing_mode.dart';
import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/Utils.dart';
import 'package:clevertap_signedcall_flutter_example/constants.dart';
import 'package:clevertap_signedcall_flutter_example/pages/dialler_page.dart';
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
  late CleverTapPlugin _clevertapPlugin;
  String _userCuid = '';
  final cuidController = TextEditingController();
  bool isLoadingVisible = false;
  bool isPoweredByChecked = false, notificationPermissionRequired = true;
  SCSwipeOffBehaviour swipeOffBehaviour = SCSwipeOffBehaviour.endCall;
  FCMProcessingMode fcmProcessingMode = FCMProcessingMode.background;
  bool isForegroundServiceChecked = false;
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final cancelCTALabelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    activateHandlers();
    initSCSDKIfCuIDSignedIn();
  }

  void pushPermissionResponseReceived(bool accepted) {
    debugPrint(
        "Push Permission response called ---> accepted = ${accepted ? "true" : "false"}");
    if (accepted) {
      showLoading();
    } else {
      CleverTapPlugin.promptPushPrimer(getPushPrimerJson());
    }
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
            const SizedBox(height: 5),
            const Text(
              'USER-REGISTRATION',
              // textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/clevertap-logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 5),
            TextField(
              controller: cuidController,
              decoration: const InputDecoration(
                hintText: 'Enter CUID',
              ),
            ),
            CheckboxListTile(
              title: const Text("Hide Powered by SignedCall"),
              value: isPoweredByChecked,
              onChanged: (newValue) {
                setState(() {
                  isPoweredByChecked = newValue ?? false;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Required Notification Permission"),
              value: notificationPermissionRequired,
              onChanged: (newValue) {
                setState(() {
                  notificationPermissionRequired = newValue ?? false;
                });
              },
              controlAffinity:
              ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Persist Call on Swipe Off in self-managed FG Service?"),
              value: swipeOffBehaviour == SCSwipeOffBehaviour.persistCall ? true : false,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    swipeOffBehaviour = newValue
                        ? SCSwipeOffBehaviour.persistCall
                        : SCSwipeOffBehaviour.endCall;
                  });
                }
              },
              controlAffinity:
              ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text("Use Foreground Service for processing FCM?"),
              value: isForegroundServiceChecked,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    isForegroundServiceChecked = newValue;
                  });
                }
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            // Show text input fields when the checkbox is checked
            if (isForegroundServiceChecked) ...[
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'FCM Notif Title',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Spacer between the fields
                  Expanded(
                    child: TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(
                        hintText: 'FCM Notif Subtitle',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              TextField(
                controller: cancelCTALabelController,
                decoration: const InputDecoration(
                  hintText: 'FCM Notif Cancel CTA Label',
                ),
              ),
            ],
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Utils.dismissKeyboard(context);
                initSignedCallSdk(cuidController.text);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Register and Continue'),
            )
          ],
        ),
      ),
    );
  }

  // Initializes the Signed Call SDK
  Future<void> initSignedCallSdk(String inputCuid) async {
    if(!Utils.didSCAccountCredentialsConfigured()) {
      Utils.showSnack(context, 'Replace the AccountId and ApiKey of your Signed Call Account in the example/lib/constants.dart');
      return;
    }

    bool isDeviceVersionTargetsBelow33 =
        await Utils.isDeviceVersionTargetsBelow(13);
    if (isDeviceVersionTargetsBelow33) {
      showLoading();
    } else {
      //showLoading() only after the notification permission result is received
      //in pushPermissionResponseReceived handler
    }

    _userCuid = inputCuid;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      Map<String, dynamic> callScreenBranding = {
        keyBgColor: "#000000",
        keyFontColor: "#ffffff",
        keyLogoUrl:
            "https://res.cloudinary.com/dsakrbtd6/image/upload/v1642409353/ct-logo_mkicxg.png",
        keyButtonTheme: "light",
        keyShowPoweredBySignedCall: !isPoweredByChecked
      };

      const missedCallActionsMap = {
        "1": "Call me back",
        "2": "Start Chat",
        "3": "Not Interested"
      };

      ///Common fields of Android & iOS
      final Map<String, dynamic> initProperties = {
        keyAccountId: scAccountId, //required
        keyApiKey: scApiKey, //required
        keyCuid: _userCuid, //required
        keyOverrideDefaultBranding: callScreenBranding ,//optional
        keyPromptPushPrimer: getPushPrimerJson()
      };

      ///Android only fields
      if (Platform.isAndroid) {
        initProperties[keyAllowPersistSocketConnection] = true; // required
        initProperties[keyPromptReceiverReadPhoneStatePermission] = true; // optional
        initProperties[keyMissedCallActions] = missedCallActionsMap; // optional
        initProperties[keyNotificationPermissionRequired] = notificationPermissionRequired; // optional
        initProperties[keySwipeOffBehaviourInForegroundService] = swipeOffBehaviour; // optional
        initProperties[keyFCMProcessingMode] = fcmProcessingMode; // optional

        if (fcmProcessingMode == FCMProcessingMode.foreground) {
          final Map<String, dynamic> fcmNotification = {
            keyFCMNotificationTitle: titleController.text, // Use input from the title field
            keyFCMNotificationSubtitle: subtitleController.text, // Use input from the subtitle field
            keyFCMNotificationLargeIcon: "ct_logo", // optional
            keyFCMNotificationCancelCtaLabel: cancelCTALabelController.text, // Use input from the Cancel CTA Label field
          };
          initProperties[keyFCMNotification] = fcmNotification; // optional
        }
      }

      ///iOS only fields
      if (Platform.isIOS) {
        initProperties[keyProduction] = false; //required
      }

      CleverTapSignedCallFlutter.shared.init(
          initProperties: initProperties, initHandler: _signedCallInitHandler);
    } on PlatformException {
      debugPrint('PlatformException occurs!');
    }
  }

  void _signedCallInitHandler(SignedCallError? signedCallInitError) async {
    debugPrint(
        "CleverTap:SignedCallFlutter: signedCallInitHandler called = ${signedCallInitError.toString()}");
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
    //save the cuid in a local session
    SharedPreferenceManager.saveLoggedInCuid(_userCuid);
    SharedPreferenceManager.savePoweredByChecked(isPoweredByChecked);
    SharedPreferenceManager.saveNotificationPermissionRequired(
        notificationPermissionRequired);
    SharedPreferenceManager.saveSwipeOffBehaviour(swipeOffBehaviour);
    SharedPreferenceManager.saveFCMProcessingMode(fcmProcessingMode);

    //Navigate the user to the Dialler Page
    Navigator.pushNamed(context, DiallerPage.routeName,
        arguments: {keyLoggedInCuid: _userCuid});
  }

  void activateHandlers() {
    _clevertapPlugin = CleverTapPlugin();
    _clevertapPlugin.setCleverTapPushPermissionResponseReceivedHandler(
        pushPermissionResponseReceived);
  }

  void initSCSDKIfCuIDSignedIn() {
    SharedPreferenceManager.getLoggedInCuid().then((loggedInCuid) {
      setState(() async {
        if (loggedInCuid != null) {
          _userCuid = loggedInCuid;
          notificationPermissionRequired =
          await SharedPreferenceManager.getNotificationPermissionRequired();
          isPoweredByChecked =
          await SharedPreferenceManager.getIsPoweredByChecked();
          swipeOffBehaviour =
          await SharedPreferenceManager.getSwipeOffBehaviour();

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

  Map<String, dynamic> getPushPrimerJson() {
    return {
      'inAppType': 'alert',
      'titleText': 'Get Notified',
      'messageText': 'Enable Notification permission',
      'followDeviceOrientation': true,
      'positiveBtnText': 'Allow',
      'negativeBtnText': 'Cancel',
      'fallbackToSettings': true
    };
  }
}
