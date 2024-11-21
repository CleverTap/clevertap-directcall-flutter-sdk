import '../src/signed_call_logger.dart';

enum FCMProcessingMode {
  /// Indicates that the SDK uses a foreground service to process FCM calls, ensuring higher priority and visibility for ongoing tasks
  foreground,

  /// Indicates that the SDK processes FCM calls using a background service on a separate background thread.
  background,
}

extension FCMPocessingModeExtentsion on FCMProcessingMode {
  /// Converts the enum value to its string representation.
  String toValue() {
    switch (this) {
      case FCMProcessingMode.foreground:
        return 'foreground';
      case FCMProcessingMode.background:
        return 'background';
    }
  }

  static FCMProcessingMode fromValue(String value) {
    switch (value) {
      case 'foreground':
        return FCMProcessingMode.foreground;
      case 'background':
        return FCMProcessingMode.background;
      default:
        SignedCallLogger.d(
            '$value is not a valid value for FCMProcessingMode.');
        return FCMProcessingMode.background;
    }
  }
}
