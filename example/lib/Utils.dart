import 'package:flutter/material.dart';

class Utils {

  Utils._();

  static void showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
