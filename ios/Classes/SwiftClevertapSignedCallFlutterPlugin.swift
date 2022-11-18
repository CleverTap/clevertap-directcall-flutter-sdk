import Flutter
import SignedCallSDK
import UIKit

//EventChannel

public class SwiftClevertapSignedCallFlutterPlugin: NSObject, FlutterPlugin {
    static var eventChannel: FlutterEventChannel?
    static var channel: FlutterMethodChannel?
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "clevertap_signedcall_flutter/methods", binaryMessenger: registrar.messenger())
        let instance = SwiftClevertapSignedCallFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        //logging to debug method
        let methodCall = SCMethodCall(rawValue: call.method)
        switch methodCall {
        case .LOGGING:
            let arguments = call.arguments as? [String: Int]
            guard arguments?[SCMethodParams.LOGLEVEL.rawValue] ?? -1 > 0 else {
                SignedCall.isLoggingEnabled = false
                result(nil)
                return
            }
            SignedCall.isLoggingEnabled = true
            //logging to debug method
            print(SignedCall.isLoggingEnabled)
            result(nil)
            
        case .INIT:
            let arguments = call.arguments as? [String: Any]
            guard let initOptions = arguments?[SCMethodParams.INITPARAM.rawValue] as? [String: Any] else {
                //logging to debug method
                result(nil)
                return
            }
            initSDK(initOptions, result: result)
            
        case .CALL:
            let arguments = call.arguments as? [String: Any]
            guard let callData = arguments?[SCMethodParams.CALLPARAM.rawValue] as? [String: Any] else {
                //logging to debug method
                result(nil)
                return
            }
            makeCall(callData, result: result)
            
        case .LOGOUT:
            logout()
            result(nil)
            
        case .HANG_UP_CALL:
            hangUpCall()
            result(nil)
            
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    func hangUpCall() {
        SignedCall.hangup()
    }
    
    func logout() {
        SignedCall.logout()
    }
    
    func initSDK(_ initOptions:[String: Any], result: @escaping FlutterResult) {
        //Update initOptions
        SignedCall.isEnabled = false
        guard let accountId = initOptions[SCMethodParams.ACCOUNTID.rawValue],
              let apiKey = initOptions[SCMethodParams.APIKEY.rawValue],
              let cuid = initOptions[SCMethodParams.CUID.rawValue] else {
            return
        }
        
        var initParams: [String: Any] = [
            "accountID": accountId,
            "apiKey": apiKey,
            "cuid" : cuid
        ]
        if let production = initOptions[SCMethodParams.PRODUCTION.rawValue] {
            initParams["production"] = production
        }
        
        if let branding = initOptions[SCMethodParams.BRANDING.rawValue] as? [String: String],
           let bgColor = branding[SCMethodParams.BGCOLOR.rawValue],
           let fontColor = branding[SCMethodParams.FONTCOLOR.rawValue],
           let logoUrl = branding[SCMethodParams.LOGOURL.rawValue],
           let buttonTheme = branding[SCMethodParams.BUTTONTHEME.rawValue] {
            let theme = buttonTheme == "light"
            SignedCall.overrideDefaultBranding = SCCallScreenBranding(bgColor: bgColor, fontColor: fontColor, logo: logoUrl, buttonTheme: theme ? .light : .dark)
        }
        
        SignedCall.initSDK(withInitOptions: initParams) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    SwiftClevertapSignedCallFlutterPlugin.channel?.invokeMethod(SCMethodParams.ON_SIGNED_CALL_DID_INITIALIZE.rawValue, arguments: nil)
                case .failure(let error):
                    SwiftClevertapSignedCallFlutterPlugin.channel?.invokeMethod(SCMethodParams.ON_SIGNED_CALL_DID_INITIALIZE.rawValue, arguments: ["error": error.errorMessage])
                }
            }
        }
    }
    
    func makeCall(_ callData:[String: Any], result: @escaping FlutterResult) {
        //Update initOptions
        guard let context = callData[SCMethodParams.CONTEXT.rawValue] as? String,
              let receiverCuid = callData[SCMethodParams.RECEIVERCUID.rawValue] as? String else {
            return
        }
        var customMetaData: SCCustomMetadata?
        if let callOptions = callData[SCMethodParams.CALLOPTIONS.rawValue] as? [String: String] {
            let initiatorImage = callOptions[SCMethodParams.INITIATORIMG.rawValue]
            let receiverImage = callOptions[SCMethodParams.RECEIVERIMG.rawValue]
            customMetaData = SCCustomMetadata(initiatorImage: initiatorImage, receiverImage: receiverImage)
        }
        
        let callOptionsModel = SCCallOptionsModel(context: context, receiverCuid: receiverCuid, customMetaData: customMetaData)
        
        SignedCall.call(callOptions: callOptionsModel) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    SwiftClevertapSignedCallFlutterPlugin.channel?.invokeMethod(SCMethodParams.ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE.rawValue, arguments: nil)
                case .failure(let error):
                    SwiftClevertapSignedCallFlutterPlugin.channel?.invokeMethod(SCMethodParams.ON_SIGNED_CALL_DID_VOIP_CALL_INITIATE.rawValue, arguments: ["error": error.errorMessage])
                }
            }
        }
    }   
}
