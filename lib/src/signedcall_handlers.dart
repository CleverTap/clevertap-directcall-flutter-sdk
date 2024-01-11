import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';

import '../models/call_status_details.dart';

/// Contains all the Signed Call Handles with their aliases
typedef SignedCallInitHandler = void Function(
    SignedCallError? signedCallInitError);

typedef SignedCallVoIPCallHandler = void Function(
    SignedCallError? signedCallVoIPCallError);

typedef OnCallEventInKilledStateHandler = void Function(SCCallStatusDetails callStatusDetails);
