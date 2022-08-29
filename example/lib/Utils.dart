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
      print('Permission granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      print(
          'Permission denied. Show a dialog and again ask for the permission');
      askMicroPhonePermission();
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    return null;
  }
}
