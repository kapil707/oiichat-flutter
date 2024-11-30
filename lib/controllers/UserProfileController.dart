import 'package:flutter/material.dart';
import 'package:oiichat/models/ChatRoomModel.dart';
import 'package:audioplayers/audioplayers.dart';

import '../Config/database_helper.dart';
import '../View/AppBar.dart';
import '../View/ChatRoomCard.dart';
import '../View/main_widget.dart';
import '../config/RealTimeService.dart';

class UserProfileController extends StatefulWidget {
  final String? user_name;
  final String? user_image;
  final String? user1;
  final String? user2;

  const UserProfileController(
      {super.key, this.user_name, this.user_image, this.user1, this.user2});

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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverHeaderDelegate(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300),
                SizedBox(height: 300)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight = 180;
  final double maxHeight = kToolbarHeight + 35;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [Positioned(child: Icon(Icons.back_hand_outlined))],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
