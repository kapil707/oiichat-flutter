import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this package for date formatting
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/database_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:sqflite/sqflite.dart';

class ChatRoomController extends StatefulWidget {
  final String? name;
  final String? user1;
  final String? user2;

  const ChatRoomController({super.key, this.name, this.user1, this.user2});

  @override
  State<ChatRoomController> createState() => _ChatRoomControllerState();
}

class _ChatRoomControllerState extends State<ChatRoomController> {
  final RealTimeService _realTimeService = RealTimeService();
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    addMessage(); // Load chat history
     _realTimeService.initSocket(widget.user1!);

     _realTimeService.onMessageReceived = (data) {
      setState(() {
        messages.add({
          'sender': widget.user2, // Assuming the other user is the sender
          'message': data,
          'timestamp': DateTime.now().toString(),
        });
      });
    };
  }

  @override
  void dispose() {
    // Disconnect the socket when leaving the screen
     _realTimeService.manual_disconnect(widget.user1!);
    _realTimeService.dispose();
    super.dispose();
  }

  Future<void> addMessage() async {
    final message = {
      'user1': 'UserA',
      'user2': 'UserB',
      'message': 'Hello, UserB!',
      'timestamp': DateTime.now().toIso8601String(),
    };
    final dbHelper = DatabaseHelper();
    int id = await dbHelper.insertMessage(message);
    print('Message inserted with ID: $id');
  }

  Future<void> loadMessages() async {

    print("Database Messages loadMessages1");
    final dbHelper = DatabaseHelper();
    final messages1 = await dbHelper.getAllMessages();
    print("Database Messages: $messages1");

    
    final chatHistory = await dbHelper.getMessages(widget.user1!, widget.user2!);
    print("loadMessages2");
    setState(() {
      messages = chatHistory;
    });
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      _realTimeService.sendMessage(widget.user1!, widget.user2!, messageController.text);

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
