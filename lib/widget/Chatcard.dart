import 'package:flutter/material.dart';
import 'package:oiichat/models/ChatModel.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chatModel});
  final ChatModel chatModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
