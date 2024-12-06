import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oiichat/config/main_config.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/models/ChatModel.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.chatModel,
    required this.your_id,
    required this.onRefresh,
  });
  final ChatModel chatModel;
  final String your_id;
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) {
    String userImage = MainConfig.image_url + chatModel.image;
    return InkWell(
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomController(
              user_name: chatModel.name,
              user_image: userImage,
              user1: your_id,
              user2: chatModel.user_id,
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
              radius: 25,
            ),
            title: Text(
              chatModel.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                if (chatModel.user_id2 != your_id) ...{
                  if (chatModel.status == 0) ...{
                    const Icon(Icons.watch_later_outlined, size: 12),
                  },
                  if (chatModel.status == 1) ...{
                    const Icon(Icons.done, size: 12),
                  },
                  if (chatModel.status == 2) ...{
                    const Icon(Icons.done_all, size: 12),
                  },
                  const SizedBox(width: 3),
                },
                Text(
                  chatModel.message,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Text(DateFormat('hh:mm a')
                .format(DateTime.parse(chatModel.time).toLocal())),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 70),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
