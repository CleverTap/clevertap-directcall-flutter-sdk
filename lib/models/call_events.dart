///Holds all the possible statuses of a VoIP call
enum CallEvent {
  //When a call is cancelled from the initiator's end
  cancelled,

  //When a call is declined from the receiver's end
  declined,

  //When a call is missed at the receiver's end
  missed,

  //When a call is picked up by the receiver
  answered,

  //When connection to the receiver is established after the call is answered.
  //Audio transfer begins at this state.
  callInProgress,

  //When a call has been ended.
  ended,

  //When the receiver is busy on another call
  receiverBusyOnAnotherCall;

  ///parses the state of the call in a [CallEvent]
  static CallEvent fromString(String state) {
    switch (state) {
      case "Cancelled":
        return CallEvent.cancelled;
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
      default:
        print('$state is not a valid CallState.');
        throw ArgumentError('$state is not a valid CallState.');
    }
  }
}
