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
  receiverBusyOnAnotherCall
}
