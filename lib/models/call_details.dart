import '../src/constants.dart';

///Contains details about the missed call
class CallDetails {
  late String callerCuid;
  late String calleeCuid;
  late String callContext;
  late String? initiatorImage;
  late String? receiverImage;

  CallDetails.fromMap(map) {
    callerCuid = map[keyCallerCuid];
    calleeCuid = map[keyCalleeCuid];
    callContext = map[keyCallContext];
    initiatorImage = map[keyInitiatorImage];
    receiverImage = map[keyReceiverImage];
  }

  @override
  String toString() {
    return 'CallDetails{callerCuid: $callerCuid, calleeCuid: $calleeCuid, callContext: $callContext, initiatorImage: $initiatorImage, receiverImage: $receiverImage}';
  }
}