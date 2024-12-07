import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Firebase initialization
        FirebaseApp.configure()

        // Register for remote notifications
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Handle FCM Token Refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase FCM Token: \(fcmToken ?? "No token generated")")
        // Optionally, send the token to your backend server
    }

    // Handle Notification Tap when App is in Background or Killed
    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) -> Bool {
        // Process notification payload
        print("Notification received with payload: \(userInfo)")
        completionHandler(UIBackgroundFetchResult.newData)
        return true
    }
}
