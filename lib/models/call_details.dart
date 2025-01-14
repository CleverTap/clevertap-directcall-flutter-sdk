import 'package:clevertap_signedcall_flutter/models/signaling_channel.dart';

import '../src/constants.dart';

///Contains details about the missed call
class CallDetails {
  late String? callId;
  late SCSignalingChannel? channel;
  late String? callerCuid;
  late String? calleeCuid;
  late String? callContext;
  late String? initiatorImage;
  late String? receiverImage;
  late String? remoteContext;

  CallDetails.fromMap(map) {
    callId = map[keyCallId];
    channel = SCSignalingChannelExtension.fromString(map[keyChannel]);
    callerCuid = map[keyCallerCuid];
    calleeCuid = map[keyCalleeCuid];
    callContext = map[keyCallContext];
    initiatorImage = map[keyInitiatorImage];
    receiverImage = map[keyReceiverImage];
    remoteContext = map[keyRemoteContext];
  }

  @override
  String toString() {
    return 'CallDetails{callId: $callId, channel: $channel, callerCuid: $callerCuid, calleeCuid: $calleeCuid, callContext: $callContext, initiatorImage: $initiatorImage, receiverImage: $receiverImage}, remoteContext: $remoteContext';
  }
}