import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oiichat/models/ChatRoomModel.dart';

import '../Config/Colors.dart';

class ChatRoomCardRight extends StatelessWidget {
  const ChatRoomCardRight({
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
          color: mainCardRightBgClr,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 60,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  chatRoomModel.message,
                  style: TextStyle(color: mainCardRightTxtClr),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Row(
                  children: [
                    Text(
                      DateFormat('hh:mma')
                          .format(DateTime.parse(chatRoomModel.time).toLocal()),
                      style: const TextStyle(
                          fontSize: 10, color: mainCardRightTxtClr),
                    ),
                    const SizedBox(width: 5),
                    if (chatRoomModel.status == 0) ...{
                      const Icon(Icons.watch_later_outlined,
                          size: 12, color: mainCardRightTxtClr),
                    },
                    if (chatRoomModel.status == 1) ...{
                      const Icon(Icons.done,
                          size: 12, color: mainCardRightTxtClr),
                    },
                    if (chatRoomModel.status == 2) ...{
                      const Icon(Icons.done_all,
                          size: 12, color: mainCardRightTxtClr),
                    },
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

class ChatRoomCardLeft extends StatelessWidget {
  const ChatRoomCardLeft({
    super.key,
    required this.chatRoomModel,
  });
  final ChatRoomModel chatRoomModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: mainCardLeftBgClr,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 60,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(chatRoomModel.message),
              ),
              Positioned(
                bottom: 4,
                right: 8,
                child: Text(
                  DateFormat('hh:mm a')
                      .format(DateTime.parse(chatRoomModel.time).toLocal()),
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
