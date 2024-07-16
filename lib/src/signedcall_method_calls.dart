class SCMethodCall {
  //Flutter to Platform
  static const String trackSdkVersion = "trackSdkVersion";
  static const String init = "init";
  static const String call = "call";
  static const String disconnectSignallingSocket = "disconnectSignallingSocket";
  static const String getCallState = "getCallState";
  static const String logout = "logout";
  static const String hangUpCall = "hangUpCall";
  static const String logging = "logging";
  static const String ackMissedCallActionClickedStream =
      "missedCallActionClicked#ack";

  //Platform to Flutter
  static const String onSignedCallDidInitialize = "onSignedCallDidInitialize";
  static const String onSignedCallDidVoIPCallInitiate =
      "onSignedCallDidVoIPCallInitiate";
}
