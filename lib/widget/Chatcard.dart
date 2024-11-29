import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return InkWell(
      onTap: () async {
      final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomController(
              user_name: chatModel.name,
              user_image: "",
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
              radius: 30,
            ),
            title: Text(
              chatModel.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(width: 3),
                Text(
                  chatModel.message,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            trailing: Text(DateFormat('hh:mm a')
                          .format(DateTime.parse(chatModel.time).toLocal())),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
