import '../src/signed_call_logger.dart';

///Holds all the possible statuses of a VoIP call
enum CallEvent {
  // Indicates that the call is successfully placed
  callIsPlaced,

  // Indicates that the call is ringing at receiver's device
  ringing,

  // Indicates that the call is cancelled from the initiator's end
  cancelled,

  // Indicates that the call is cancelled due to a ring timeout
  cancelledDueToRingTimeout,

  // Indicates that the call is declined from the receiver's end
  declined,

  // Indicates that the call is missed at the receiver's end
  missed,

  // Indicates that the call is picked up by the receiver
  answered,

  // Indicates that the connection to the receiver is established and the audio transfer begins at this state
  callInProgress,

  // Indicates that the call has been ended.
  ended,

  // Indicates that the receiver is already busy on another call
  receiverBusyOnAnotherCall,

  // Indicates that the call is declined due to the receiver being logged out with the specific CUID
  declinedDueToLoggedOutCuid,

  // [Specific to Android-Platform]
  // Indicates that the call is declined due to the notifications are disabled at the receiver's end.
  declinedDueToNotificationsDisabled,

  // Indicates that the microphone permission is not granted for the call.
  declinedDueToMicrophonePermissionsNotGranted,

  // Indicates that the microphone permission is blocked at the receiver's end.
  declinedDueToMicrophonePermissionBlocked,

  // Indicates that the call is declined due to receiver is busy on a VoIP call.
  declinedDueToBusyOnVoIP,

  // Indicates that the call is declined due to receiver is busy on a PSTN call.
  declinedDueToBusyOnPSTN,

  // Indicates that the call is failed due to an internal error.
  // Possible reasons could include low internet connectivity, low RAM available
  // on device or SDK fails to set up the voice channel within the time limit.
  failedDueToInternalError;

  ///parses the state of the call in a [CallEvent]
  static CallEvent fromString(String state) {
    switch (state) {
      case "CallIsPlaced":
        return CallEvent.callIsPlaced;
      case "Ringing":
        return CallEvent.ringing;
      case "Cancelled":
        return CallEvent.cancelled;
      case "CancelledDueToRingTimeout":
        return CallEvent.cancelledDueToRingTimeout;
      case "Declined":
        return CallEvent.declined;
      case "Missed":
        return CallEvent.missed;
      case "Answered":
        return CallEvent.answered;
      case "CallInProgress":
        return CallEvent.callInProgress;
      case "Ended":
        return CallEvent.ended;
      case "ReceiverBusyOnAnotherCall":
        return CallEvent.receiverBusyOnAnotherCall;
      case "DeclinedDueToLoggedOutCuid":
        return CallEvent.declinedDueToLoggedOutCuid;
      case "DeclinedDueToNotificationsDisabled":
        return CallEvent.declinedDueToNotificationsDisabled;
      case "DeclinedDueToMicrophonePermissionsNotGranted":
        return CallEvent.declinedDueToMicrophonePermissionsNotGranted;
      case "DeclinedDueToMicrophonePermissionBlocked":
        return CallEvent.declinedDueToMicrophonePermissionBlocked;
      case "DeclinedDueToBusyOnVoIP":
        return CallEvent.declinedDueToBusyOnVoIP;
      case "DeclinedDueToBusyOnPSTN":
        return CallEvent.declinedDueToBusyOnPSTN;
      case "FailedDueToInternalError":
        return CallEvent.failedDueToInternalError;
      default:
        SignedCallLogger.d('$state is not a valid CallState.');
        throw ArgumentError('$state is not a valid CallState.');
    }
  }
}
