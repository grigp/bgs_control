//import Flutter
import UIKit
import workmanager

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
//    GeneratedPluginRegistrant.register(withRegistry: self)
    
    // In AppDelegate.application method
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "counter_texel")

    // Register a periodic task in iOS 13+
    WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "com.example.bgsControl.iOSBackgroundAppRefresh", frequency: NSNumber(value: 20 * 60))

    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
