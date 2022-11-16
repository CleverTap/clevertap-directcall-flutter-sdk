import Flutter
import UIKit
import SignedCallSDK

public class SwiftClevertapSignedCallFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "clevertap_signedcall_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftClevertapSignedCallFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
        result("iOS \(UIDevice.current.systemVersion)");
 
    default: result(FlutterMethodNotImplemented)
    }
  }
  
}
