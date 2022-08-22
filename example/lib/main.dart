import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:clevertap_directcall_flutter/clevertap_directcall_flutter.dart';

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
  final String _directCallInitStatus = 'Unknown';
  late ClevertapDirectcallFlutter _clevertapDirectcallFlutterPlugin;

  @override
  void initState() {
    super.initState();
    setup();
    //activateDirectCallFlutterPluginHandlers();
    initDirectCallSdk();
  }

  void setup() {
    _clevertapDirectcallFlutterPlugin = ClevertapDirectcallFlutter();
  }

  void directCallDidInitialize(Map<String, dynamic>? map) {
    setState(() {
      print("directCallDidInitialize called = ${map.toString()}");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initDirectCallSdk() async {
    String directCallInitStatus;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      /* DirectCallInitOptions directCallInitOptionsBuilder =
          DirectCallInitOptionsBuilder(initJson, true)
              .setEnableReadPhoneState(true)
              .build();*/

      const initJson = {
        keyAccountId: dcAccountId,
        keyApiKey: dcApiKey,
        keyCuid: "ct_shiv"
      };

      var initOptions = {
        keyInitJson: jsonEncode(initJson), // <--JSON String
        keyAllowPersistSocketConnection: true
      };

      _clevertapDirectcallFlutterPlugin.init(
          initOptions, directCallDidInitialize);
    } on PlatformException {
      directCallInitStatus = 'Failed to initialize the Direct Call SDK.';
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
}
