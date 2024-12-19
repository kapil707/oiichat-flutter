import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification tap or action
        if (notificationResponse.payload != null) {
          print('Notification Payload: ${notificationResponse.payload}');
          // Navigate to a specific screen or perform logic here
        }
      },
    );
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
      payload: 'incoming_call', // Pass data for navigation or handling
    );
  }
}
