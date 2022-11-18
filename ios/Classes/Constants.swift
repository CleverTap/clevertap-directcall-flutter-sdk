import Foundation


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
    case INITIATORIMG = "initiator_image"
    case RECEIVERIMG = "receiver_image"
    
    //Platform to Flutter
    case ON_SIGNED_CALL_DID_INITIALIZE = "onSignedCallDidInitialize"
    case ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE = "onSignedCallDidVoIPCallInitiate"
}

