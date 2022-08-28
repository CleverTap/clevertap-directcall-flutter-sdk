import 'package:clevertap_directcall_flutter/models/log_level.dart';

///Extension of [LogLevel] enum class
extension LogLevelExtension on LogLevel {
  ///Returns the raw integer value associated with the various [LogLevel] levels
  int get rawValue {
    switch (this) {
      case LogLevel.off:
        return -1;
      case LogLevel.info:
        return 0;
      case LogLevel.debug:
        return 2;
      case LogLevel.verbose:
        return 3;
    }
  }
}
