import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:oiichat/RealTimeService.dart'; // Your real-time service class
import 'package:oiichat/database_helper.dart'; // SQLite helper class
import 'package:oiichat/models/Message.dart';
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
  final RealTimeService _realTimeService = RealTimeService();
  late IO.Socket socket;
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final dbHelper = DatabaseHelper();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    loadMessages(); // Load chat history from SQLite

    // Initialize socket connection for real-time messaging
    _realTimeService.initSocket(widget.user1!);

    // Handle incoming messages from the server
    _realTimeService.onMessageReceived = (data) {
      
      setState(() {
        messages.add({
          'sender': widget.user2!,
          'message': data,
          'timestamp': DateTime.now().toString(),
        });
      });
      // Scroll to the bottom
      scrollToBottom();
    };
  }

  @override
  void dispose() {
    // Disconnect from the server and cleanup resources
    _realTimeService.manual_disconnect(widget.user1!);
    _realTimeService.dispose();
    messageController.dispose(); // Dispose the message controller
    super.dispose();
  }

  // Load chat history from the database
  Future<void> loadMessages() async {
    print("Loading messages from database...");
    final chatHistory = await dbHelper.getMessages(widget.user1!, widget.user2!);
    print("Loaded ${chatHistory.length} messages");

    setState(() {
      for (var message in chatHistory) {
        String sender = widget.user2!;
        if(message.user1==widget.user1){
          sender = widget.user1!;
        }
        messages.add({
          'sender': sender,
          'message': message.message,
          'timestamp': message.timestamp,
        });
      }
    });
  }

  // Handle sending a message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      // Update the UI
      setState(() {
        messages.add({
          'sender': widget.user1,
          'message': messageController.text,
          'timestamp': DateTime.now().toString(),
        });
      });
      // Send the message to the server
      _realTimeService.sendMessage(widget.user1!, widget.user2!, messageController.text);
      messageController.clear();
      // Scroll to the bottom
      scrollToBottom();
    }
  }

  Future<void> deleteChat() async {
    try {
      // Delete messages from the database
      await dbHelper.deleteMessages(widget.user1!, widget.user2!);

      // Clear the messages list in the UI
      setState(() {
        messages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Chat deleted successfully")),
      );
    } catch (e) {
      print("Error deleting chat: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete chat")),
      );
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent, // Move to the end of the list
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name ?? "Chat Room"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Confirm delete action
              final confirmDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete Chat"),
                  content: Text("Are you sure you want to delete this chat?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                await deleteChat(); // Call the delete function
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // Attach the ScrollController
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isSentByUser1 = msg['sender'] == widget.user1; // Check sender
                final screenWidth = MediaQuery.of(context).size.width; // Screen width

                return Align(
                  alignment: isSentByUser1
                      ? Alignment.centerRight
                      : Alignment.centerLeft, // Align messages
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.7, // 70% of screen width
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isSentByUser1
                            ? Colors.grey[300] // Background for user1
                            : Colors.blue[200], // Background for user2
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: isSentByUser1
                              ? Radius.circular(0)
                              : Radius.circular(12),
                          bottomRight: isSentByUser1
                              ? Radius.circular(12)
                              : Radius.circular(0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['message'],
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DateFormat('hh:mm a')
                                  .format(DateTime.parse(msg['timestamp']).toLocal()),
                              style: TextStyle(fontSize: 10, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Field for Sending Messages
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