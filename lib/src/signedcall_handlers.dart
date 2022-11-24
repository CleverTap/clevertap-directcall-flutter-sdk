import 'package:clevertap_signedcall_flutter/models/signed_call_error.dart';

/// Contains all the Signed Call Handles with their aliases
typedef SignedCallInitHandler = void Function(
    SignedCallError? signedCallInitError);

typedef SignedCallVoIPCallHandler = void Function(
    SignedCallError? signedCallVoIPCallError);
