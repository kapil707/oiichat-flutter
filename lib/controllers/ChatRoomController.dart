
import 'package:flutter/material.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoomController extends StatefulWidget {
  final String? user1;
  final String? user2;

  const ChatRoomController({super.key, this.user1, this.user2});

  @override
  State<ChatRoomController> createState() => _ChatRoomControllerState();
}

class _ChatRoomControllerState extends State<ChatRoomController> {

  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io('http://192.168.1.9:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Join room
    String roomId = [widget.user1, widget.user2].join('_');
    socket.emit('joinRoom', {'user1': widget.user1, 'user2': widget.user2});

    // Receive previous messages
    socket.on('previousMessages', (data) {
      setState(() {
        messages = List<Map<String, dynamic>>.from(data);
      });
    });

    // Receive real-time messages
    socket.on('receiveMessage', (data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      String roomId = [widget.user1, widget.user2].join('_');
      socket.emit('sendMessage', {
        'roomId': roomId,
        'sender': widget.user1,
        'message': messageController.text,
      });

      setState(() {
        messages.add({
          'sender': widget.user1,
          'message': messageController.text,
          'timestamp': DateTime.now().toString(),
        });
      });

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(
                    msg['sender'] == widget.user1 ? "You" : msg['sender'],
                    style: TextStyle(
                        fontWeight: msg['sender'] == widget.user1
                            ? FontWeight.bold
                            : FontWeight.normal),
                  ),
                  subtitle: Text(msg['message']),
                  trailing: Text(
                    DateTime.parse(msg['timestamp']).toLocal().toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}