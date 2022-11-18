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
    switch call.method {
    case "logging":
        guard let arguments = call.arguments as? [String: Int], arguments["logLevel"] ?? -1 > 0 else {
            SignedCall.isLoggingEnabled = false
            return
        }
        SignedCall.isLoggingEnabled = true
        print(SignedCall.isLoggingEnabled)
        result(nil);
        
    case "init":
        guard let arguments = call.arguments as? [String: Any], let initOptions = arguments["initProperties"] as? [String: Any] else {
            //add fail log
            result(nil);
            return
        }
        initSDK(initOptions, result: result)
        SwiftClevertapSignedCallFlutterPlugin.channel?.invokeMethod("onSignedCallDidInitialize", arguments: nil)

        
    case "call":
        guard let arguments = call.arguments as? [String: Any], let callData = arguments["callProperties"] as? [String: Any] else {
            //add fail log
            result(nil);
            return
        }
        makeCall(callData, result: result)
        
    case "logout": logout()
        
    case "hangUpCall": hangUpCall()
        
 
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
        guard let accountId = initOptions["accountId"],
                let apiKey = initOptions["apiKey"],
              let branding = initOptions["overrideDefaultBranding"],
              let cuid = initOptions["cuid"] else {
            return
        }
              
        let initParams: [String: Any] = [
            "accountID": "61a52046f56a14cb19a1e9cc",
            "apiKey": "9dcced09dae16c5e3606c22346d92361b77efdb360425913850bea4f22d812dd",
//            "production": true,
            "cuid" : "sonalll"
        ]
        
        SignedCall.initSDK(withInitOptions: initParams) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let success):
                    print("SDK Initialized! \(success)")
//                    self.channel?.invokeMethod("ON_SIGNED_CALL_DID_INITIALIZE", arguments: ["success": true])
                case .failure(let error):
                    print("SDK initialization failed \(error.errorMessage)")
//                    result("\(error.errorMessage)")

//                    self.channel?.invokeMethod("ON_SIGNED_CALL_DID_INITIALIZE", arguments: ["error": error.errorMessage])
                }
            }
        }
    }
    
    func makeCall(_ callData:[String: Any], result: @escaping FlutterResult) {
        //Update initOptions
        guard let context = callData["callContext"] as? String,
              let receiverCuid = callData["receiverCuid"] as? String else {
            return
        }
        var customMetaData: SCCustomMetadata?
        if let callOptions = callData["callOptions"] as? [String: Any] {
            //        let customMetaData = SCCustomMetadata(initiatorImage: nil, receiverImage: nil)

        }

        let callOptionsModel = SCCallOptionsModel(context: context, receiverCuid: receiverCuid, customMetaData: customMetaData)

        SignedCall.call(callOptions: callOptionsModel) { [weak self] result in
//            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let value): print(value)
                case .failure(let error): print(error)
                }
            }
        }
    }
    
    
  
}
