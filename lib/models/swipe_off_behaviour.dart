import '../src/signed_call_logger.dart';

/// Enum representing the possible statuses of a Swipe Off Behavior during an ongoing call.
enum SCSwipeOffBehaviour {
  /// Indicates the behavior where the call is ended when the user swipes off the app.
  endCall,

  /// Indicates the behavior where the call persists even if the user swipes off the app.
  persistCall,
}

extension SCSwipeOffBehaviourExtension on SCSwipeOffBehaviour {
  /// Converts the enum value to its string representation.
  String toValue() {
    switch (this) {
      case SCSwipeOffBehaviour.endCall:
        return 'endCall';
      case SCSwipeOffBehaviour.persistCall:
        return 'persistCall';
    }
  }

  static SCSwipeOffBehaviour fromValue(String value) {
    switch (value) {
      case 'endCall':
        return SCSwipeOffBehaviour.endCall;
      case 'persistCall':
        return SCSwipeOffBehaviour.persistCall;
      default:
        SignedCallLogger.d(
            '$value is not a valid value for SCSwipeOffBehaviour.');
        return SCSwipeOffBehaviour.persistCall;
    }
  }
}
