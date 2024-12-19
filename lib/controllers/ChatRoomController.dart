import 'package:flutter/material.dart';
import 'package:oiichat/Controllers/UserProfileController.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/config/database_helper.dart';
import 'package:oiichat/controllers/UserCall.dart';
import 'package:oiichat/controllers/call2.dart';
import 'package:oiichat/models/ChatRoomModel.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:oiichat/view/AppBar.dart';
import 'package:oiichat/view/ChatRoomCard.dart';
import 'package:oiichat/view/main_widget.dart';

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
      final newMessage = ChatRoomModel(
        message: data,
        time: DateTime.now().toString(),
        user_id: widget.user2!,
        status: 0,
      );
      setState(() {
        messages.add(newMessage);
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
    //print('chatlist $chatHistory');
    setState(() {
      messages = chatHistory;
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

      _realTimeService.sendMessage(
        widget.user1!,
        widget.user2!,
        messageController.text,
      );

      setState(() {
        messages.add(
          ChatRoomModel(
            user_id: widget.user1!,
            message: messageController.text,
            time: DateTime.now().toIso8601String(),
            status: 0,
          ),
        );
      });

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
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WhatsAppAppBar(
        userName: widget.user_name!,
        userStatus: UserStatus!,
        profileImageUrl: widget.user_image!,
        onProfilePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileController(
                user_name: widget.user_name,
                user_image: widget.user_image,
                user1: widget.user1!,
                user2: widget.user2,
                user_status: UserStatus,
              ),
            ),
          );
        },
        onCallPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OutGoingCallScreen(
                        user1: widget.user1!,
                        user2: widget.user2!,
                        UserName: widget.user_name!,
                        UserImage: widget.user_image!,
                        calltype: "Calling...",
                      )));
        },
        onVideoCallPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VideoCallScreen(
                        user1: widget.user1!,
                        user2: widget.user2!,
                      )));
        },
        onMorePressed: () => print("More options pressed"),
      ),
      body: Container(
        color: const Color(0xFFECE5DD),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              //height: MediaQuery.of(context).size.height + 150,
              child:
                  // Messages List
                  ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Container(height: 70);
                  }
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
              child: SizedBox(
                height: 70,
                child: ChatInputBox(
                  messageController: messageController,
                  onSend: sendMessage,
                  messageFocus: _focusNode,
                  emojiOpen: _toggleEmojiPicker,
                  onTypingStatus: _handleTypingStatus,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
