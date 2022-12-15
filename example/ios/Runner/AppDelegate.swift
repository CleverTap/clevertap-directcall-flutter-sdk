import UIKit
import Flutter
import CleverTapSDK
import SignedCallSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        CleverTap.setDebugLevel(CleverTapLogLevel.off.rawValue)
        CleverTap.autoIntegrate()
        SignedCall.cleverTapInstance = CleverTap.sharedInstance()
        guard let rootView = self.window?.rootViewController else {
            return true
        }
        SignedCall.registerVoIP(withRootView: rootView)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
