import Foundation
import SignedCallSDK

public let SCCallStatusDidUpdate: NSNotification.Name = NSNotification.Name(rawValue: "SCCallStatusDidUpdate")

enum SCChannel: String {
    case methodChannel = "clevertap_signedcall_flutter/methods"
    case eventChannel = "clevertap_signedcall_flutter/events/call_event"
}

struct SCCallEventMapping {
    var callStatus: SCCallStatus?
    var value: String {
        switch callStatus {
        case .CALL_DECLINED_DUE_TO_LOGGED_OUT_CUID:
            "DeclinedDueToLoggedOutCuid"
        case .CALLEE_MICROPHONE_PERMISSION_NOT_GRANTED:
            "DeclinedDueToMicrophonePermissionsNotGranted"
        case .CALL_IS_PLACED:
            "CallIsPlaced"
        case .CALLEE_BUSY_ON_ANOTHER_CALL:
            "ReceiverBusyOnAnotherCall"
        case .CALL_CANCELLED:
            "Cancelled"
        case .CALL_DECLINED:
            "Declined"
        case .CALL_MISSED:
            "Missed"
        case .CALL_ANSWERED:
            "Answered"
        case .CALL_IN_PROGRESS:
            "CallInProgress"
        case .CALL_OVER:
            "Ended"
        case .CALL_DECLINED_DUE_TO_NOTIFICATIONS_DISABLED:
            "DeclinedDueToNotificationsDisabled"
        case .DELAYED_ANSWER_ACTION:
            ""
        case .none:
            "none"
        @unknown default:
            "unknow"
        }
    }
}


struct SCCallEvent: RawRepresentable {
    var rawValue: Int
    
    var value: String {
        switch rawValue {
        case 3001: return "Ended"
            
        case 3006: return "Cancelled"
        case 3002: return "Answered"
        case 3003: return "Declined"
        case 3004: return "Missed"
        case 3005: return "ReceiverBusyOnAnotherCall"
        case 3009: return "Ended"
        case 3010: return "CallInProgress"
            
        case 3007: return "DelayAction"
        case 3008: return "MicrophonePermission"
        case 3011: return "SuccessCall"
        default: return "" 
        }
    }
}

enum SCMethodCall: String {
    
    //Flutter to Platform
    case INIT = "init"
    case CALL = "call"
    case LOGOUT = "logout"
    case HANG_UP_CALL = "hangUpCall"
    case LOGGING = "logging"
    case DISCONNECTSOCKET = "disconnectSignallingSocket"
    case TRACKSDKVERSION = "trackSdkVersion"
    
    //Platform to Flutter
    case ON_SIGNED_CALL_DID_INITIALIZE = "onSignedCallDidInitialize"
    case ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE = "onSignedCallDidVoIPCallInitiate"
}

enum SCMethodParams: String {
    
    //Flutter to Platform
    case LOGLEVEL = "logLevel"
    case INITPARAM = "initProperties"
    case CALLPARAM = "callProperties"
    case HANG_UP_CALL = "hangUpCall"
    case LOGGING = "logging"
    
    //init
    case ACCOUNTID = "accountId"
    case APIKEY = "apiKey"
    case CUID = "cuid"
    case PRODUCTION = "production"
    case BRANDING = "overrideDefaultBranding"
    case POWEREDBY = "showPoweredBySignedCall"
    
    //branding
    case BGCOLOR = "bgColor"
    case FONTCOLOR = "fontColor"
    case LOGOURL = "logoUrl"
    case BUTTONTHEME = "buttonTheme"
    
    //call
    case CONTEXT = "callContext"
    case RECEIVERCUID = "receiverCuid"
    case CALLOPTIONS = "callOptions"
    
    //calloptions
    case REMOTE_CONTEXT = "remoteContext"
    case INITIATORIMG = "initiatorImage"
    case RECEIVERIMG = "receiverImage"
    
    //error keys
    case errorCode = "errorCode"
    case errorMessage = "errorMessage"
    case errorDescription = "errorDescription"
    
    //Platform to Flutter
    case ON_SIGNED_CALL_DID_INITIALIZE = "onSignedCallDidInitialize"
    case ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE = "onSignedCallDidVoIPCallInitiate"
}


