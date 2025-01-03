import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/Config/notification.dart';
import 'package:oiichat/config/Colors.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/config/database_helper.dart';
import 'package:oiichat/config/main_functions.dart';
import 'package:oiichat/controllers/StatusPage.dart';
import 'package:oiichat/controllers/UserCall.dart';
import 'package:oiichat/models/ChatModel.dart';
import 'package:oiichat/config/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';
import 'package:oiichat/view/AppDrawer.dart';
import 'package:oiichat/view/ChatCard.dart';

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
  String? your_name;
  String? your_image;

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
  }

  void refreshChatList() {
    // Simulate refreshing the chat list
    print("Refreshing chat list...");
    _handlePageLoad();
  }

  @override
  void dispose() {
    //_realTimeService.manual_disconnect(your_id!);
    //_realTimeService.dispose();
    super.dispose();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      your_id = userSessionData['userId'];
      your_name = userSessionData['userName'];
      your_image = userSessionData['userImage'];
      loadChats();

      // Initialize the real-time service
      _realTimeService.initSocket(your_id!);
      _realTimeService.GetOldMessage(your_id!);
      // Listen for new messages and refresh the chat list
      _realTimeService.onMessageReceived = (data) {
        loadChats();
      };
      _realTimeService.onMessageReceivedNew = (data) {
        print("get_old_message_response 2ok");
        loadChats();
      };

      _realTimeService.onIncomingCall = (data) async {
        try {
          print("oiicall newcall " + your_id! + " - " + data["user1"]);

          final refresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => IncomingCallScreen(
                        user1: your_id!,
                        user2: data["user1"],
                        UserName: data["user_name"],
                        UserImage: data["user_image"],
                        //onDecline: onDecline,
                      )));
          if (refresh == true) {
            _handlePageLoad();
          }
        } catch (e) {
          print("oiicall : $e");
        }
      };
    });
  }

  Future<void> loadChats() async {
    final chatList = await dbHelper.getChatList(your_id!);
    //print('get_old_message_response chatlist $chatList');
    setState(() {
      chats = chatList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oii Chat"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          PopupMenuButton(
            onSelected: (value) {
              print(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: "New Group",
                  child: Text("New Group"),
                ),
                const PopupMenuItem(
                  value: "Setting",
                  child: Text("Setting"),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorColor: mainTabTxtColor,
          labelColor: mainTabTxtColor,
          unselectedLabelColor: mainUnTabTxtColor,
          tabs: const [
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
      drawer: AppDrawer(
        your_id: your_id,
        your_name: your_name,
        your_image: your_image,
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          const Text("camra"),
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
          Statuspage(
            your_id: your_id,
            your_name: your_name,
            your_image: your_image,
          ),
          Statuspage(
            your_id: your_id,
            your_name: your_name,
            your_image: your_image,
          ),
        ],
      ),
    );
  }
}
