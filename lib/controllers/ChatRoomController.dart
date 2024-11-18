
import 'package:flutter/material.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoomController extends StatefulWidget {
  final String? name;
  final String? user1;
  final String? user2;

  const ChatRoomController({super.key, this.name, this.user1, this.user2 });

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
    socket = IO.io('http://192.168.1.7:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true, // Enable reconnection
      'reconnectionAttempts': 5, // Retry 5 times before giving up
      'reconnectionDelay': 2000, // Wait 2 seconds before retrying
    });

    // Register the userId with the server
    socket.on('connect', (_) {
      socket.emit('register', widget.user1);
      print('Connected to server as ${widget.user1}');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });

    // Reconnect listener
    socket.on('reconnect', (_) {
      print('Reconnected to server');
      socket.emit('registerUser', widget.user1); // Re-register user
    });

    // Receive real-time messages
    socket.on('receiveMessage', (data) {
      print("receiveMessage"+data["message"]);
       setState(() {
        messages.add({
          'sender': widget.user2,
          'message':data['message'],
          'timestamp': DateTime.now().toString(),
        });
      });
    });

    // Handle user offline message
    socket.on('user_offline', (data) {
        print('User ${data['user2']} is offline.');
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      socket.emit('sendMessage', {
        'user1': widget.user1,
        'user2': widget.user2,
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
      appBar: AppBar(title: Text(widget.name!)),
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