import 'package:flutter/material.dart';
import 'package:oiichat/config/main_config.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/models/FriendPageModel.dart';

class FriendsCard extends StatelessWidget {
  const FriendsCard({
    super.key,
    required this.friendPageModel,
    required this.your_id,
    required this.onRefresh,
  });
  final FriendPageModel friendPageModel;
  final String your_id;
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) {
    String userImage = friendPageModel.userImage;
    return InkWell(
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomController(
              user_name: friendPageModel.name,
              user_image: userImage,
              user1: your_id,
              user2: friendPageModel.id,
            ),
          ),
        );
        if (refresh == true) {
          onRefresh(); // Call the parent page's refresh function
        }
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
              radius: 28,
            ),
            title: Text(
              friendPageModel.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Row(
              children: [
                Text(
                  "hello",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
