import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:oiichat/AppBar.dart';
import 'package:oiichat/RealTimeService.dart'; // Your real-time service class
import 'package:oiichat/database_helper.dart'; // SQLite helper class
import 'package:oiichat/models/ChatRoomModel.dart';
import 'package:oiichat/models/useri_info_model.dart';
import 'package:oiichat/widget/ChatRoomCard.dart';
import 'package:oiichat/widget/main_widget.dart';
import 'package:audioplayers/audioplayers.dart';

class ChatRoomController extends StatefulWidget {
  final String? user_name;
  final String? user_image;
  final String? user1;
  final String? user2;

  const ChatRoomController(
      {super.key, this.user_name, this.user_image, this.user1, this.user2});

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

  String? UserStatus;
  List<ChatRoomModel> messages = [];
  bool _isEmojiPickerOpen = false;
  int typingStatus = 0;

  @override
  void initState() {
    super.initState();
    loadMessages();
    insertOrUpdateUserInfo();
    // Focus on the input field initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    setState(() {
      UserStatus = "Loading...";
    });

    // Initialize Socket connection
    _realTimeService.initSocket(widget.user1!);
    _realTimeService.GetUserInfo(widget.user2!);

    _realTimeService.onUserInfoReceived = (data) {
      if (data["user_id"] == widget.user2) {
        setState(() {
          UserStatus = data["status"];
        });
      }
    };

    _realTimeService.onUserTypingReceived = (data) {
      if (data["status"] == "1") {
        setState(() {
          UserStatus = "typing...";
        });
      } else {
        _realTimeService.GetUserInfo(widget.user2!);
      }
    };

    // Handle incoming messages
    _realTimeService.onMessageReceived = (data) {
      setState(() {
        // messages.add({
        //   'status': 1, // Message delivered
        //   'sender': widget.user2!,
        //   'message': data,
        //   'timestamp': DateTime.now().toString(),
        // });
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

  void _handleTypingStatus(int status) {
    setState(() {
      typingStatus = status;
    });

    // Optionally, send the typing status to the server
    if (status == 1) {
      print("User is typing...");
      _realTimeService.userTyping(widget.user1!, widget.user2!, "1");
    } else {
      print("User stopped typing.");
      _realTimeService.userTyping(widget.user1!, widget.user2!, "0");
    }
  }

  void insertOrUpdateUserInfo() async {
    //user ki info insert or update hotai ha yaha say
    // final newUser = UseriInfoModel(
    //   user_id: widget.user2!,
    //   user_name: widget.name!,
    // );
    // await dbHelper.insertOrUpdateUserInfo(newUser);
  }

  void playNotificationSound() async {
    try {
      await _audioPlayer.play(AssetSource('notification_sound.mp3'));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  Future<void> loadMessages() async {
    print('chatlist call');
    final chatHistory =
        await dbHelper.ChatRoomMessage(widget.user1!, widget.user2!);
    print('chatlist $chatHistory');
    setState(() {
      messages = chatHistory;
      //   // messages = chatHistory
      //   //     .map((message) => {
      //   //           'status': message.status,
      //   //           'sender':
      //   //               message.user1 == widget.user1 ? widget.user1 : widget.user2,
      //   //           'message': message.message,
      //   //           'timestamp': message.timestamp,
      //   //         })
      //   //     .toList();
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
      _realTimeService.userTyping(widget.user1!, widget.user2!, "0");
      setState(() {
        // messages.add({
        //   'status': 0, // Sent but not delivered yet
        //   'sender': widget.user1,
        //   'message': messageController.text,
        //   'timestamp': DateTime.now().toString(),
        // });
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
        userName: widget.user_name!,
        userStatus: UserStatus!,
        profileImageUrl: widget.user_image!,
        onCallPressed: () => print("Call button pressed"),
        onVideoCallPressed: () => print("Video call button pressed"),
        onMorePressed: () => print("More options pressed"),
      ),
      body: Container(
        color: const Color(0xFFECE5DD),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 140,
              width: MediaQuery.of(context).size.width,
              child:
                  // Messages List
                  ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (messages[index].user_id == widget.user1) {
                    return ChatRoomCardRight(
                      chatRoomModel: messages[index],
                    );
                  } else {
                    return ChatRoomCardLeft(
                      chatRoomModel: messages[index],
                    );
                  }
                },
              ),
            ),
            // Input Box
            Align(
              alignment: Alignment.bottomCenter,
              child: ChatInputBox(
                messageController: messageController,
                onSend: sendMessage,
                messageFocus: _focusNode,
                emojiOpen: _toggleEmojiPicker,
                onTypingStatus: _handleTypingStatus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
