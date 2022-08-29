import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter.dart';
import 'package:clevertap_directcall_flutter_example/constants.dart';
import 'package:clevertap_directcall_flutter_example/pages/dialler_page.dart';
import 'package:clevertap_directcall_flutter_example/pages/registration_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static final ClevertapDirectcallFlutter _clevertapDirectcallFlutterPlugin =
      ClevertapDirectcallFlutter();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
          builder: (context) => RegistrationPage(
              title: "Direct Call Sample",
              clevertapDirectcallFlutterPlugin:
                  _clevertapDirectcallFlutterPlugin));
    } else if (settings.name == DiallerPage.routeName) {
      Map loggedInCuid = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) => DiallerPage(
              loggedInCuid: loggedInCuid[keyLoggedInCuid],
              clevertapDirectcallFlutterPlugin:
                  _clevertapDirectcallFlutterPlugin));
    } else {
      return MaterialPageRoute(
          builder: (context) => RegistrationPage(
              title: "Direct Call Sample",
              clevertapDirectcallFlutterPlugin:
                  _clevertapDirectcallFlutterPlugin));
    }
  }
}
