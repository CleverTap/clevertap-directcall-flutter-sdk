import 'dart:async';
import 'dart:convert';

import 'package:clevertap_directcall_flutter/clevertap_directcall_flutter.dart';
import 'package:clevertap_directcall_flutter/models/call_events.dart';
import 'package:clevertap_directcall_flutter/models/missed_call_action_click_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _directCallInitStatus = 'Unknown';
  late ClevertapDirectcallFlutter _clevertapDirectcallFlutterPlugin;
  static const int _callMeterDurationInSeconds = 15;
  late StreamSubscription<CallEvent>? _callEventSubscription;
  late StreamSubscription<MissedCallActionClickResult>?
      _missedCallActionClickEventSubscription;

  @override
  void initState() {
    super.initState();
    setup();
    initDirectCallSdk();
  }

  void setup() {
    _clevertapDirectcallFlutterPlugin = ClevertapDirectcallFlutter();
  }

  Future<void> _directCallInitHandler(
      Map<String, dynamic>? directCallInitError) async {
    if (kDebugMode) {
      print(
          "CleverTap:DirectCallFlutter: directCallInitHandler called = ${directCallInitError.toString()}");
    }
    if (directCallInitError == null) {
      _startObservingCallEvents();
      _startObservingMissedCallActionClickEvents();

      //_clevertapDirectcallFlutterPlugin.logout();
      var isEnabled = await _clevertapDirectcallFlutterPlugin.isEnabled();
      //isEnabled is true when the Direct Call SDK is enabled to initiate or receive a call otherwise false
      if (isEnabled == true) {
        initiateVoIPCall();
      }
    }
  }

  void _directCallVoIPCallHandler(Map<String, dynamic>? directCallVoIPError) {
    if (kDebugMode) {
      print(
          "CleverTap:DirectCallFlutter: directCallVoIPCallHandler called = ${directCallVoIPError.toString()}");
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectCallSdk() async {
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

      var initProperties = {
        keyAccountId: dcAccountId,
        keyApiKey: dcApiKey,
        keyCuid: "clevertap_dev",
        keyAllowPersistSocketConnection: true, //Android Platform
        keyEnableReadPhoneState: true, //Android Platform
        keyOverrideDefaultBranding: callScreenBranding, //Android Platform
        keyMissedCallActions: missedCallActionsMap //Android Platform
      };

      _clevertapDirectcallFlutterPlugin.init(
          initProperties: initProperties, initHandler: _directCallInitHandler);
    } on PlatformException {
      _directCallInitStatus = 'Failed to initialize the Direct Call SDK.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_directCallInitStatus\n'),
        ),
      ),
    );
  }

  void initiateVoIPCall() {
    //const callOptions = {keyInitiatorImage: null, keyReceiverImage: null};

    _clevertapDirectcallFlutterPlugin.call(
        receiverCuid: "ct_receiver",
        callContext: "test call",
        callOptions: null,
        voIPCallHandler: _directCallVoIPCallHandler);
  }

  //Listens to the real-time stream of call-events
  void _startObservingCallEvents() {
    _callEventSubscription =
        _clevertapDirectcallFlutterPlugin.callEventListener.listen((event) {
      if (kDebugMode) {
        print(
            "CleverTap:DirectCallFlutter: received callEvent stream with ${event.toString()}");
      }
      if (event == CallEvent.answered) {
        _startCallDurationMeterToEndCall();
      }
    });
  }

  void _startObservingMissedCallActionClickEvents() {
    _missedCallActionClickEventSubscription = _clevertapDirectcallFlutterPlugin
        .missedCallActionClickListener
        .listen((result) {
      if (kDebugMode) {
        print(
            "CleverTap:DirectCallFlutter: received missedCallActionClickResult stream with ${result.toString()}");
      }
    });
  }

  //Starts a timer and hang up the active call when timer finishes
  void _startCallDurationMeterToEndCall() {
    Timer(const Duration(seconds: _callMeterDurationInSeconds), () {
      _clevertapDirectcallFlutterPlugin.hangUpCall();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _callEventSubscription?.cancel();
    _missedCallActionClickEventSubscription?.cancel();
  }
}
