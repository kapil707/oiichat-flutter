import 'package:flutter/material.dart';

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
            delegate: CustomSliverHeaderDelegate(widget.user_image),
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                        widget.user_name!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      Text(
                        widget.user_name!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300),
                const SizedBox(height: 300)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomSliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 20;
  final double maxImageSize = 130;
  final double minImageSize = 40;
  final user_image;

  CustomSliverHeaderDelegate(this.user_image);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / (maxHeaderHeight);
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((size.width / 2 - 65) * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        color: Theme.of(context)
            .appBarTheme
            .backgroundColor!
            .withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
        child: Stack(
          children: [
            Positioned(
                left: currentImagePosition + 50,
                top: MediaQuery.of(context).viewPadding.top + 15,
                child: const Text(
                  "Vedant",
                  style: TextStyle(color: Colors.white),
                )),
            Positioned(
                left: 0,
                top: MediaQuery.of(context).viewPadding.top + 2,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: percent2 > .3
                          ? Colors.white.withOpacity(percent2)
                          : null,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    })),
            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
            Positioned(
                left: currentImagePosition,
                top: MediaQuery.of(context).viewPadding.top + 5,
                bottom: 0,
                child: Container(
                  width: currentImageSize,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(user_image))),
                )),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
