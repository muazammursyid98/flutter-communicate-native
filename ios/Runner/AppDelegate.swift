import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let methodChannelNameScan = "environment_activity_method_channel"
      let methodChannelName = "environment_sensors/method"
      let pressureChannelName = "environment_sensors/pressure"
      let ambientTemperatureChannelName = "environment_sensors/temperature"
      let humidityChannelName = "environment_sensors/humidity"
      let lightChannelName = "environment_sensors/light"

      let controller: FlutterViewController  = window?.rootViewController as! FlutterViewController

      let methodChannel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: controller.binaryMessenger)
      
      let pressureStream = PressureStreamHandler()
      
      methodChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "isSensorAvailable":
              result(CMAltimeter.isRelativeAltitudeAvailable())
    
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      let pressureEventChannel = FlutterEventChannel(name: pressureChannelName, binaryMessenger: controller.binaryMessenger)
      pressureEventChannel.setStreamHandler(pressureStream)
      
      let methodChannelScan = FlutterMethodChannel(name: methodChannelNameScan, binaryMessenger: controller.binaryMessenger)
      
      methodChannelScan.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "open_new_activity":
                 // Create a new view controller and present it
                 let storyboard = UIStoryboard(name: "Main", bundle: nil)
                 let viewController = storyboard.instantiateViewController(withIdentifier: "ScanViewController")
                 controller.present(viewController, animated: true, completion: nil)
                 result(true) // Return nil to indicate success
          default:
              result(FlutterMethodNotImplemented)
          }
      })
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}