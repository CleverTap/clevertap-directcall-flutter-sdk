import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  Utils._();

  static void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static Future<bool?> askMicroPhonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      print('Microphone permission granted!');
      return true;
    } else if (status == PermissionStatus.denied) {
      print('Microphone permission denied!');
      askMicroPhonePermission();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Takes the user to the settings page');
      await openAppSettings();
    }
    return null;
  }
}
