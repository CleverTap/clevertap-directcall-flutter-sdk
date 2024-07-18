import '../src/signed_call_logger.dart';

/// Holds all the possible statuses of a VoIP call.
enum SCCallState {
  outgoingCall,
  incomingCall,
  ongoingCall,
  cleanupCall,
  noCall;

  /// Parses the state of the call into a [SCCallState].
  static SCCallState? fromString(String state) {
    switch (state) {
      case "OutgoingCall":
        return SCCallState.outgoingCall;
      case "IncomingCall":
        return SCCallState.incomingCall;
      case "OngoingCall":
        return SCCallState.ongoingCall;
      case "CleanupCall":
        return SCCallState.cleanupCall;
      case "NoCall":
        return SCCallState.noCall;
      default:
        SignedCallLogger.d('$state is not a valid value for SCCallState.');
        return null;
    }
  }
}
