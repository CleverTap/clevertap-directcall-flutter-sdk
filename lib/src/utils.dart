import '../models/call_events.dart';

class Utils {
  //Private constructor
  Utils._();

  ///parses the state of the call in a [CallEvent]
  static CallEvent parseCallEvent(String state) {
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
