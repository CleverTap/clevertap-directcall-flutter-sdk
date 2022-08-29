import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class SharedPreferenceManager {
  static Future<bool> saveLoggedInCuid(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(keyLoggedInCuid, token);
  }

  static Future<String?> getLoggedInCuid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyLoggedInCuid);
  }

  static removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyLoggedInCuid);
  }
}
