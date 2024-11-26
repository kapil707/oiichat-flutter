
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class MyNotification extends StatelessWidget {
  const MyNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(title: Text("Oii Chat"),),
      body: Column(
        children: [
          Text(message.notification!.title.toString())
        ],
      ),
    );
  }
}