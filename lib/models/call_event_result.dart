import '../src/constants.dart';
import 'call_details.dart';
import 'call_events.dart';

/// Represents the result of a call event
class CallEventResult {
  late final CallDirection direction;
  late final CallDetails callDetails;
  late final CallEvent? callEvent;

  CallEventResult.fromMap(Map resultMap) {
    direction = resultMap[keyDirection] == 'INCOMING'
        ? CallDirection.incoming
        : CallDirection.outgoing;

    callDetails = CallDetails.fromMap(resultMap[keyCallDetails] ?? {});

    callEvent = CallEvent.fromString(resultMap[keyCallEvent] ?? '');
  }

  @override
  String toString() {
    return 'CallEventResult{direction: $direction, callDetails: $callDetails, callEvent: $callEvent}';
  }
}

/// Enumeration representing the direction of a call (incoming or outgoing).
enum CallDirection { incoming, outgoing }
