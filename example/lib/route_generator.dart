import 'package:clevertap_signedcall_flutter/plugin/clevertap_signedcall_flutter.dart';
import 'package:clevertap_signedcall_flutter_example/constants.dart';
import 'package:clevertap_signedcall_flutter_example/pages/dialler_page.dart';
import 'package:clevertap_signedcall_flutter_example/pages/registration_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static final ClevertapSignedCallFlutter _clevertapSignedcallFlutterPlugin =
      ClevertapSignedCallFlutter();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
          builder: (context) => RegistrationPage(
              title: "Signed Call Sample",
              clevertapSignedCallFlutterPlugin:
                  _clevertapSignedcallFlutterPlugin));
    } else if (settings.name == DiallerPage.routeName) {
      Map arguments = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) => DiallerPage(
              loggedInCuid: arguments[keyLoggedInCuid],
              clevertapSignedCallFlutterPlugin:
                  _clevertapSignedcallFlutterPlugin));
    } else {
      return MaterialPageRoute(
          builder: (context) => RegistrationPage(
              title: "Signed Call Sample",
              clevertapSignedCallFlutterPlugin:
                  _clevertapSignedcallFlutterPlugin));
    }
  }
}
