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
    String user_image = "http://160.30.100.216:3000/"+chatModel.image;    
    return InkWell(
      onTap: () async {
      final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomController(
              user_name: chatModel.name,
              user_image: user_image,
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
              backgroundImage: NetworkImage(user_image),
              radius: 28,
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
                if(chatModel.user_id2!=your_id)...{
                  if(chatModel.status==0)...{ 
                    Icon(Icons.watch_later_outlined,size: 12),
                  },  
                  if(chatModel.status==1)...{ 
                    Icon(Icons.done,size: 12),
                  },
                  if(chatModel.status==2)...{ 
                    Icon(Icons.done_all,size: 12),
                  },
                  SizedBox(width: 3),
                },
                Text(
                  chatModel.message,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            trailing: Text(DateFormat('hh:mm a')
                          .format(DateTime.parse(chatModel.time).toLocal())),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30,right: 30),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
