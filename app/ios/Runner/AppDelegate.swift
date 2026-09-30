import UIKit
import Flutter
import GoogleMaps
import OSLog

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GMSServices.provideAPIKey(Bundle.main.infoDictionary!["googleMapsKey"] as! String)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        
        setupThemePlugin(engineBridge: engineBridge)
    }
    
    private func setupThemePlugin(engineBridge: FlutterImplicitEngineBridge) {
        let themeChannel = FlutterMethodChannel(
            name: "app.tankste.settings/theme",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )
        themeChannel.setMethodCallHandler(
            { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
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
            }
        )
    }
}
