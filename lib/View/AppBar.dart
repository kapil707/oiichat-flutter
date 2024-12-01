import 'package:flutter/material.dart';

class WhatsAppAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userStatus;
  final String profileImageUrl;
  final VoidCallback onProfilePressed;
  final VoidCallback onCallPressed;
  final VoidCallback onVideoCallPressed;
  final VoidCallback onMorePressed;

  const WhatsAppAppBar({
    super.key,
    required this.userName,
    required this.userStatus,
    required this.profileImageUrl,
    required this.onProfilePressed,
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
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
          ),
        ],
      ),
      title: InkWell(
        onTap: onProfilePressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                userStatus, // e.g., "Online" or "Last seen at..."
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: onCallPressed, // Action for voice call
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: onVideoCallPressed, // Action for video call
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: onMorePressed, // Action for more options
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class UserProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UserProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 50,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      ),
      title: const Text("User Profile"),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
