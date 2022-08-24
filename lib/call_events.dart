///Holds all the possible statuses of a VoIP call
enum CallEvent {
  //When the call is cancelled from the initiator's end
  cancelled,

  //When the call is declined from the receiver's end
  declined,

  //When the call is missed at the receiver's end
  missed,

  //When the call is picked up by the receiver
  answered,

  //The connection to the receiver is established and the audio transfer begins at this state
  callInProgress,

  //The call has been disconnected.
  ended,

  //When the receiver is already busy on another call
  receiverBusyOnAnotherCall
}
