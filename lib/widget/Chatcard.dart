import 'package:flutter/material.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/models/ChatModel.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chatModel, required this.your_id});
  final ChatModel chatModel;
  final String your_id;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomController(
              user_name: chatModel.name,
              user_image: "",
              user1: your_id,
              user2: chatModel.user_id, // Pass user ID or name
            ),
          ),
        );
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
            trailing: Text(chatModel.time),
          ),
          Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}
