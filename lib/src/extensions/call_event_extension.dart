import 'package:clevertap_directcall_flutter/models/call_events.dart';

///Extension of [LogLevel] enum class
extension CallEventExtension on CallEvent {
  ///Takes the [state] as a target and returns the parsed [CallEvent] type.
  CallEvent fromString(String state) {
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
