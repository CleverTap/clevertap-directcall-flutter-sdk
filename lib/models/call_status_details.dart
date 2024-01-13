import 'call_events.dart';
import 'missed_call_action_click_result.dart';

enum CallDirection { incoming, outgoing }

class SCCallStatusDetails {
  late final CallDirection direction;
  late final CallDetails callDetails;
  late final CallEvent callEvent;

  SCCallStatusDetails.fromMap(Map resultMap) {
    direction = resultMap['direction'] == 'INCOMING'
        ? CallDirection.incoming
        : CallDirection.outgoing;

    callDetails = CallDetails.fromMap(resultMap['callDetails'] ?? {});

    callEvent = CallEvent.fromString(resultMap['callEvent']);
  }

  @override
  String toString() {
    return 'SCCallStatusDetails{direction: $direction, callDetails: $callDetails, callEvent: $callEvent}';
  }
}
