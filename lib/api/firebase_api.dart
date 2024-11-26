
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:oiichat/main.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('Title ${message.notification?.title}');
// }

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('token: $FCMToken');
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