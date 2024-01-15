import 'package:clevertap_signedcall_flutter/models/log_level.dart';

class SignedCallLogger {
  static const String _defaultTagPrefix = "[CT]:[SignedCall]:[Flutter]";

  ///SET APP LOG LEVEL, Default ALL
  static int _currentLogLevel = LogLevel.info.value;

  static setLogLevel(int priority) {
    _currentLogLevel = priority;
  }

  ///Print general logs
  static v(String message, {String tag = _defaultTagPrefix}) {
    _log(LogLevel.verbose, tag, message);
  }

  ///Print info logs
  static i(String message, {String tag = _defaultTagPrefix}) {
    _log(LogLevel.info, tag, message);
  }

  ///Print debug logs
  static d(String message, {String tag = _defaultTagPrefix}) {
    _log(LogLevel.debug, tag, message);
  }

  static _log(LogLevel priority, String tag, String message) {
    if (_currentLogLevel > priority.value) {
      print("$tag: $message");
    }
  }
}
