import 'package:clevertap_signedcall_flutter/src/constants.dart';

import 'call_details.dart';

///Provides the call and action-button details associated to a missed call notification
class MissedCallActionClickResult {
  late MissedCallNotificationAction action;
  late CallDetails callDetails;

  MissedCallActionClickResult.fromMap(Map resultMap) {
    action = MissedCallNotificationAction.fromMap(resultMap[keyAction]);
    callDetails = CallDetails.fromMap(resultMap[keyCallDetails]);
  }

  @override
  String toString() {
    return 'MissedCallActionClickResult{action: $action, callDetails: $callDetails}';
  }
}

///Contains details about the clicked action-button
class MissedCallNotificationAction {
  late String actionID;
  late String actionLabel;

  MissedCallNotificationAction.fromMap(map) {
    actionID = map[keyActionId];
    actionLabel = map[keyActionLabel];
  }

  @override
  String toString() {
    return 'MissedCallNotificationAction{actionID: $actionID, actionLabel: $actionLabel}';
  }
}
