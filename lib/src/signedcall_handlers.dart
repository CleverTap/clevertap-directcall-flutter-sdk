/// Contains all the Signed Call Handles with their aliases
typedef SignedCallInitHandler = void Function(
    Map<String, dynamic>? signedCallInitError);

typedef SignedCallVoIPCallHandler = void Function(
    Map<String, dynamic>? signedCallVoIPCallError);
