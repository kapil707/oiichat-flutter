
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oiichat/main.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title ${message.notification?.title}');
// }

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {

    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }

    // Setup foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received in foreground: ${message.notification?.title}");
    });

    //await _firebaseMessaging.requestPermission();
    //final FCMToken = await _firebaseMessaging.getToken();
    //print('token: $FCMToken');
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message){
    if(message==null) return;

    navigatorKey.currentState?.pushNamed(
      '/Notification',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}