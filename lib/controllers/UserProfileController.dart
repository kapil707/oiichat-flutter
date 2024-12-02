import 'package:flutter/material.dart';

import '../config/database_helper.dart';
import '../view/AppBar.dart';
import '../view/ChatRoomCard.dart';
import '../view/main_widget.dart';
import '../config/RealTimeService.dart';

class UserProfileController extends StatefulWidget {
  final String? user_name;
  final String? user_image;
  final String? user1;
  final String? user2;
  final String? user_status;

  const UserProfileController(
      {super.key,
      this.user_name,
      this.user_image,
      this.user1,
      this.user2,
      this.user_status});

  @override
  State<UserProfileController> createState() => _UserProfileControllerState();
}

class _UserProfileControllerState extends State<UserProfileController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherPageAppBar(your_title: "User Profile"),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.user_image!),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.user_name!,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.user_status!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
