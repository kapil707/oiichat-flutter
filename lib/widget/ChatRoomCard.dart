import 'package:flutter/material.dart';
import 'package:oiichat/models/ChatRoomModel.dart';

class ChatRoomCard extends StatelessWidget {
  const ChatRoomCard({
    super.key,
    required this.chatRoomModel,
  });
  final ChatRoomModel chatRoomModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 60,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(chatRoomModel.message),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      chatRoomModel.time,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.done_all,
                      size: 16,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
