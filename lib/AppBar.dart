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
      leadingWidth: 80,
      backgroundColor: Colors.teal, // WhatsApp's typical color
      elevation: 1.0,
      leading: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            height: 60,
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl), // Profile picture
            ),
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              userStatus, // e.g., "Online" or "Last seen at..."
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.call, color: Colors.white),
          onPressed: onCallPressed, // Action for voice call
        ),
        IconButton(
          icon: Icon(Icons.videocam, color: Colors.white),
          onPressed: onVideoCallPressed, // Action for video call
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.white),
          onPressed: onMorePressed, // Action for more options
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
