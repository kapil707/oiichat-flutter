import 'package:flutter/material.dart';

class WhatsAppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userStatus;
  final String profileImageUrl;
  final VoidCallback onCallPressed;
  final VoidCallback onVideoCallPressed;
  final VoidCallback onMorePressed;

  WhatsAppAppBar({
    required this.userName,
    required this.userStatus,
    required this.profileImageUrl,
    required this.onCallPressed,
    required this.onVideoCallPressed,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 90,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
          ),
        ],
      ),
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              userStatus, // e.g., "Online" or "Last seen at..."
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call),
          onPressed: onCallPressed, // Action for voice call
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: onVideoCallPressed, // Action for video call
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: onMorePressed, // Action for more options
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
