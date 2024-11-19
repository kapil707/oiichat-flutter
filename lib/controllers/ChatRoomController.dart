import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatRoomController extends StatefulWidget {
  final String? name;
  final String? user1;
  final String? user2;

  const ChatRoomController({super.key, this.name, this.user1, this.user2});

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

  @override
  void dispose() {
    // Disconnect the socket when leaving the screen
    socket.disconnect();
    super.dispose();
  }

  void connectToServer() {
  // Initialize the socket connection
  socket = IO.io('http://192.168.1.7:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  // Establish the connection
  socket.connect();

  // Handle connection event
  socket.on('connect', (_) {
    print('Connected to server as ${socket.id}');
    // Register the user on connection
    socket.emit("register", widget.user1);
  });

  // Handle disconnection
  socket.on('disconnect', (_) {
    print('Disconnected from server: ${widget.user1}');
  });

  // Handle connection errors
  socket.on('connect_error', (error) {
    print('Connection error: $error');
  });

  // Handle incoming messages
  socket.on('receiveMessage', (data) {
    print("Message received: ${data["message"]}");
    setState(() {
      messages.add({
        'sender': data['sender'],
        'message': data['message'],
        'timestamp': data['timestamp'] ?? DateTime.now().toString(),
      });
    });
  });

  // Handle user offline status
  socket.on('user_offline', (data) {
    print('User ${data['user']} is offline.');
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
      appBar: AppBar(title: Text(widget.name ?? "Chat Room")),
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
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(msg['message']),
                  trailing: Text(
                    DateFormat('hh:mm a')
                        .format(DateTime.parse(msg['timestamp']).toLocal()),
                    style: TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
