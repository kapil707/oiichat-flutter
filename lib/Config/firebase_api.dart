import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oiichat/controllers/UserCall.dart';
import 'package:oiichat/main.dart';
import 'package:oiichat/service/wakelock_service.dart';

final FlutterLocalNotificationsPlugin _notificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }

    // Setup foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "oiicall Message received in foreground: ${message.notification?.title}");

      // Wake up screen when message is received
      await WakelockService.wakeScreen();

      // Navigate to Incoming Call Screen
      // navigatorKey.currentState?.push(MaterialPageRoute(
      //   builder: (context) => IncomingCallScreen(
      //     user1: "111",
      //     user2: "2222",
      //     UserName: "kamal",
      //     UserImage: "",
      //   ),
      // ));

      // Show local notification
      await _notificationsPlugin.show(
        0,
        message.notification?.title ?? 'New Message',
        message.notification?.body ?? 'You have a new message',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'default_channel', // Channel ID
            'Default Notifications', // Channel name
            channelDescription: 'Notifications for app messages',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    //await _firebaseMessaging.requestPermission();
    //final FCMToken = await _firebaseMessaging.getToken();
    //print('token: $FCMToken');
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/Notification',
      arguments: message,
    );
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

  static Future<void> showCallNotification(
      String callerName, String callType) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'incoming_call_channel', // Channel ID
      'Incoming Calls', // Channel name
      channelDescription: 'Notifications for incoming calls',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true, // Makes the notification full-screen
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0, // Notification ID
      '$callerName is calling', // Title
      'Call Type: $callType', // Body
      platformChannelSpecifics,
      payload: 'incoming_call', // Pass data for navigation
    );
    // Wake up the screen
    await WakelockService.wakeScreen();
  }
}
