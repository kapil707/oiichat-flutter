import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/view/AppBar.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/config/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';

import '../config/main_functions.dart';
import '../config/RealTimeService.dart';

class FriendController extends StatefulWidget {
  const FriendController({super.key});

  @override
  State<FriendController> createState() => _FriendControllerState();
}

class _FriendControllerState extends State<FriendController> {
  final RealTimeService _realTimeService = RealTimeService();
  List<Map<String, dynamic>> users = []; // Store users list

  String? user1;

  final apiService = MyApiService(Dio());
  late final HomeService homeService;
  @override
  void initState() {
    super.initState();
    homeService = HomeService(apiService);
    _handlePageLoad();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      user1 = userSessionData['userId']!;
    });
  }

  Future<void> fetchData() async {
    try {
      print("Fetching home page data...");
      final res = await apiService.home_page_api("xx"); // Fetch data from API

      setState(() {
        users = res.users!
            .map((user) => {
                  'name': user.name,
                  'email': user.email,
                  '_id': user.sId,
                })
            .toList();
      });

      print("Data fetched successfully: ${users.length} users found");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserProfileAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: users.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator if no data
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user['name'] ?? 'No Name'),
                    subtitle: Text(user['email'] ?? 'No Email'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomController(
                            user_name: user['name'],
                            user_image: "",
                            user1: user1,
                            user2: user['_id'], // Pass user ID or name
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
