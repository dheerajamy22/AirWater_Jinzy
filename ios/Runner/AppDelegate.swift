import UIKit
import Flutter
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
   // GMSServices.provideAPIKey("AIzaSyBkrNLp172wmSS5otyJH7xedzNMs4t_59o")
    application.statusBarStyle = .lightContent
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
//Old API-KEY AIzaSyBkrNLp172wmSS5otyJH7xedzNMs4t_59o

//GMSServices.provideAPIKey("AIzaSyD2tBWdnui2ifrzV-RlnzQYRySaRqXCgQ0")
