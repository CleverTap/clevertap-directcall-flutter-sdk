import '../src/signed_call_logger.dart';

/// Enum representing the possible channels used for delivering call notifications.
enum SCSignalingChannel {
  /// Indicates a socket-based channel used to deliver the incoming call to the receiver.
  socket,

  /// Indicates an FCM-based channel used to deliver the incoming call to the receiver.
  fcm,
}

extension SCSignalingChannelExtension on SCSignalingChannel {
  /// Converts the string representation of a signaling channel to its enum value.
  static SCSignalingChannel? fromString(String value) {
    switch (value) {
      case 'socket':
        return SCSignalingChannel.socket;
      case 'fcm':
        return SCSignalingChannel.fcm;
      default:
        SignedCallLogger.d(
            '$value is not a valid value for SCSignalingChannel.');
        return null;
    }
  }

  /// Converts the enum value to its string representation.
  String toValue() {
    switch (this) {
      case SCSignalingChannel.socket:
        return 'socket';
      case SCSignalingChannel.fcm:
        return 'fcm';
    }
  }
}