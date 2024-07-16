/// Enum representing the possible channels used for delivering call notifications.
enum SCSignalingChannel {
  /// Indicates a socket-based channel used to deliver the incoming call to the receiver.
  socket,

  /// Indicates an FCM-based channel used to deliver the incoming call to the receiver.
  fcm,
}
