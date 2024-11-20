import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/database_helper.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/models/HomePageModel.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';
import 'package:oiichat/widget/main_widget.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  final RealTimeService _realTimeService = RealTimeService();
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> chats = [];

  String? user1;

  final apiService = MyApiService(Dio());
  late final HomeService homeService;
  @override
  void initState() {
    super.initState();
    homeService = HomeService(apiService);
    _handlePageLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handlePageLoad(); // Reload the chats when returning to this screen
  }


  @override
  void dispose() {
    _realTimeService.manual_disconnect(user1!);
    _realTimeService.dispose();
    super.dispose();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      user1 = userSessionData['userName']!;
      loadChats();
      // Initialize the real-time service
      _realTimeService.initSocket(user1!);

      // Listen for new messages and refresh the chat list
      _realTimeService.onMessageReceived = (data) {
        loadChats();
      };
    });
  }

  Future<void> loadChats() async {
    final chatList = await dbHelper.getChatList(user1!);
    setState(() {
      chats = chatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      drawer: AppDrawer(),
      body: chats.isEmpty
          ? const Center(child: Text("No chats available"))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final lastMessageTime = DateTime.parse(chat['lastMessageTime']);
                String chatuser =
                    chat['chatUser'] == user1 ? user1 : chat['chatUser'];

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/default_avatar.png'), // Replace with profile photo
                    radius: 25,
                  ),
                  title: Text(
                    chatuser,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat['message'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    DateFormat('hh:mm a').format(lastMessageTime),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  onTap: () {
                    // Navigate to Chat Room
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomController(
                          name: chatuser,
                          user1: user1,
                          user2: chatuser,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
