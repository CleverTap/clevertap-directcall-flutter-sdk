import 'package:clevertap_signedcall_flutter/models/swipe_off_behaviour.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SharedPreferenceManager {
  static Future<bool> saveLoggedInCuid(String cuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(keyLoggedInCuid, cuid);
  }

  static Future<String?> getLoggedInCuid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLoggedInCuid);
  }

  static Future<bool> savePoweredByChecked(bool isChecked) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyIsPoweredByChecked, isChecked);
  }

  static Future<bool> getIsPoweredByChecked() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsPoweredByChecked) ?? false;
  }

  static Future<bool> saveNotificationPermissionRequired(bool isRequired) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyNotificationPermissionRequired, isRequired);
  }

  static Future<bool> getNotificationPermissionRequired() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyNotificationPermissionRequired) ?? true;
  }

  static Future<bool> saveSwipeOffBehaviour(SCSwipeOffBehaviour behaviour) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(keySwipeOffBehaviour, behaviour.toValue());
  }

  static Future<SCSwipeOffBehaviour> getSwipeOffBehaviour() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final behaviourString = prefs.getString(keySwipeOffBehaviour) ?? SCSwipeOffBehaviour.endCall.toValue();
    return SCSwipeOffBehaviourExtension.fromValue(behaviourString);
  }

  static Future<bool> saveCallScreenOnSignalling(bool isChecked) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(keyCallScreenOnSignalling, isChecked);
  }

  static Future<bool> getCallScreenOnSignalling() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyCallScreenOnSignalling) ?? true;
  }


  static clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyLoggedInCuid);
  }
}
