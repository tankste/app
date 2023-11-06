import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupThemePlugin()
        
        GMSServices.provideAPIKey(Bundle.main.infoDictionary!["googleMapsKey"] as! String)
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func setupThemePlugin() {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let themeChannel = FlutterMethodChannel(name: "app.tankste.settings/theme",
                                                binaryMessenger: controller.binaryMessenger)
        themeChannel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "setTheme" {
                if #available(iOS 13.0, *) {
                    let args = call.arguments as? [String : Any] ?? [:]
                    let value = args["value"] as? String
                    
                    if value == "light" {
                        self.window?.overrideUserInterfaceStyle = .light
                    } else if value == "dark" {
                        self.window?.overrideUserInterfaceStyle = .dark
                    } else {
                        self.window?.overrideUserInterfaceStyle = .unspecified
                    }
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        })
    }
}
