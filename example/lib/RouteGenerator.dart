import 'package:clevertap_directcall_flutter_example/pages/dialler_page.dart';
import 'package:clevertap_directcall_flutter_example/pages/registration_page.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (settings.name == "/") {
      return MaterialPageRoute(
          builder: (context) => const RegistrationPage(title: "Direct Call Sample"));
    } else if (settings.name == DiallerPage.routeName) {
      Map loggedInCuid = settings.arguments as Map;
      return MaterialPageRoute(
          builder: (context) =>
              DiallerPage(loggedInCuid: loggedInCuid["loggedInCuid"]));
    } else {
      return MaterialPageRoute(
          builder: (context) => const RegistrationPage(title: "Direct Call Sample"));
    }
  }
}
