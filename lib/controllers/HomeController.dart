import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/controllers/StatusPage.dart';
import 'package:oiichat/Config/main_functions.dart';
import 'package:oiichat/models/ChatModel.dart';
import 'package:oiichat/config/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';

import '../Config/Colors.dart';
import '../Config/database_helper.dart';
import '../View/AppDrawer.dart';
import '../View/ChatCard.dart';

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController>
    with SingleTickerProviderStateMixin {
  final RealTimeService _realTimeService = RealTimeService();
  final dbHelper = DatabaseHelper();
  List<ChatModel> chats = [];

  String? your_id;

  late TabController _controller;

  final apiService = MyApiService(Dio());
  late final HomeService homeService;
  @override
  void initState() {
    super.initState();
    //homeService = HomeService(apiService);
    //_handlePageLoad();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handlePageLoad(); // Reload the chats when returning to this screen
    print("call me");
  }

  void refreshChatList() {
    // Simulate refreshing the chat list
    print("Refreshing chat list...");
    _handlePageLoad();
  }

  @override
  void dispose() {
    _realTimeService.manual_disconnect(your_id!);
    _realTimeService.dispose();
    super.dispose();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      your_id = userSessionData['userId']!;
      loadChats();
      // Initialize the real-time service
      _realTimeService.initSocket(your_id!);
      // Listen for new messages and refresh the chat list
      _realTimeService.onMessageReceived = (data) {
        loadChats();
      };
    });
  }

  Future<void> loadChats() async {
    final chatList = await dbHelper.getChatList(your_id!);
    print('chatlist $chatList');
    setState(() {
      chats = chatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OiiChat"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton(onSelected: (value) {
            print(value);
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Text("New Group"),
                value: "New Group",
              ),
              PopupMenuItem(
                child: Text("Setting"),
                value: "Setting",
              ),
            ];
          })
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: mainTabTxtColor,
          labelColor: mainTabTxtColor,
          unselectedLabelColor: mainUnTabTxtColor,
          tabs: [
            Tab(icon: Icon(Icons.camera_alt)),
            Tab(
              text: "Chat",
            ),
            Tab(
              text: "Status",
            ),
            Tab(
              text: "Call",
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
      body: TabBarView(
        controller: _controller,
        children: [
          Text("camra"),
          chats.isEmpty
              ? const Center(child: Text("No chats available"))
              : Container(
                  child: Column(
                    children: [
                      // Chat Messages List
                      Expanded(
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return ChatCard(
                              your_id: your_id!,
                              chatModel: chats[index],
                              onRefresh: refreshChatList,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
          Statuspage(),
        ],
      ),
    );
  }
}
