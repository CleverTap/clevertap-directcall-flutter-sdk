import Foundation
import SignedCallSDK

enum SCChannel: String {
    case methodChannel = "clevertap_signedcall_flutter/methods"
    case eventChannel = "clevertap_signedcall_flutter/events/call_event"
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


