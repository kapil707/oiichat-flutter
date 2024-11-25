import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:oiichat/AppBar.dart';
import 'package:oiichat/RealTimeService.dart'; // Your real-time service class
import 'package:oiichat/database_helper.dart'; // SQLite helper class
import 'package:oiichat/models/Message.dart';
import 'package:oiichat/widget/main_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:audioplayers/audioplayers.dart';

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
  final TextEditingController messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final dbHelper = DatabaseHelper();

  List<Map<String, dynamic>> messages = [];
  bool _isEmojiPickerOpen = false;

  @override
  void initState() {
    super.initState();
    loadMessages();

    // Focus on the input field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });

    // Initialize Socket connection
    _realTimeService.initSocket(widget.user1!);

    // Handle incoming messages
    _realTimeService.onMessageReceived = (data) {
      setState(() {
        messages.add({
          'status': 1, // Message delivered
          'sender': widget.user2!,
          'message': data,
          'timestamp': DateTime.now().toString(),
        });
      });
      playNotificationSound();
      scrollToBottom();
    };

    // Handle message sent event
    _realTimeService.onMessageSend = (data) {
      messages.clear();
      loadMessages();
    };
  }

  @override
  void dispose() {
    // Clean up resources
    _realTimeService.manual_disconnect(widget.user1!);
    _realTimeService.dispose();
    messageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('notification_sound.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> loadMessages() async {
    final chatHistory = await dbHelper.getMessages(widget.user1!, widget.user2!);
    setState(() {
      messages = chatHistory
          .map((message) => {
                'status': message.status,
                'sender': message.user1 == widget.user1
                    ? widget.user1
                    : widget.user2,
                'message': message.message,
                'timestamp': message.timestamp,
              })
          .toList();
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiPickerOpen = !_isEmojiPickerOpen;
      if (_isEmojiPickerOpen) {
        _focusNode.unfocus(); // Hide the keyboard
      } else {
        _focusNode.requestFocus(); // Show the keyboard
      }
    });
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'status': 0, // Sent but not delivered yet
          'sender': widget.user1,
          'message': messageController.text,
          'timestamp': DateTime.now().toString(),
        });
      });

      _realTimeService.sendMessage(
        widget.user1!,
        widget.user2!,
        messageController.text,
      );

      messageController.clear();
      scrollToBottom();
    }
  }

  Future<void> deleteChat() async {
    try {
      await dbHelper.deleteMessages(widget.user1!, widget.user2!);
      setState(() {
        messages.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Chat deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete chat")),
      );
    }
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsAppAppBar(
        userName: widget.user2!,
        userStatus: "Online",
        profileImageUrl: "https://via.placeholder.com/150",
        onCallPressed: () => print("Call button pressed"),
        onVideoCallPressed: () => print("Video call button pressed"),
        onMorePressed: () => print("More options pressed"),
      ),
      body: Container(
        color: const Color(0xFFECE5DD), // WhatsApp-like background
        child: Column(
          children: [
            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isSentByUser1 = msg['sender'] == widget.user1;

                  return Align(
                    alignment: isSentByUser1
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isSentByUser1
                              ? Colors.grey[300]
                              : Colors.blue[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: isSentByUser1
                                ? Radius.zero
                                : Radius.circular(12),
                            bottomRight: isSentByUser1
                                ? Radius.circular(12)
                                : Radius.zero,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['message'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.parse(msg['timestamp']).toLocal(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Icon(
                                  msg['status'] == 0
                                      ? Icons.watch_later
                                      : Icons.check,
                                  size: 13,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Input Box
            ChatInputBox(
              messageController: messageController,
              onSend: sendMessage,
              messageFocus: _focusNode,
              emojiOpen: _toggleEmojiPicker,
            ),
          ],
        ),
      ),
    );
  }
}
