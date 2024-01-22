import 'package:clevertap_signedcall_flutter/models/missed_call_action_click_result.dart';
import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';

import '../models/call_event_result.dart';

/// Contains all the Signed Call Handles with their aliases
typedef SignedCallInitHandler = void Function(
    SignedCallError? signedCallInitError);

typedef SignedCallVoIPCallHandler = void Function(
    SignedCallError? signedCallVoIPCallError);

typedef BackgroundCallEventHandler = void Function(
    CallEventResult callStatusDetails);

typedef BackgroundMissedCallActionClickedHandler = void Function(
    MissedCallActionClickResult callStatusDetails);
