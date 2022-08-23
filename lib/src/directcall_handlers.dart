/// Contains all the Direct Call Handles with their aliases
typedef DirectCallInitHandler = void Function(
    Map<String, dynamic>? directCallInitError);

typedef DirectCallVoIPCallHandler = void Function(
    Map<String, dynamic>? directCallVoIPCallError);
