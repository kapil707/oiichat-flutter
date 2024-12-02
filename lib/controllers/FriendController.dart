import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/models/FriendPageModel.dart';
import 'package:oiichat/view/AppBar.dart';
import 'package:oiichat/config/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';
import 'package:oiichat/view/FriendsCard.dart';

import '../config/main_functions.dart';
import '../config/RealTimeService.dart';

class FriendController extends StatefulWidget {
  const FriendController({super.key});

  @override
  State<FriendController> createState() => _FriendControllerState();
}

class _FriendControllerState extends State<FriendController> {
  final RealTimeService _realTimeService = RealTimeService();
  List<FriendPageModel> users = []; // Store users list
  //List<Map<String, dynamic>> users = [];

  String? your_id;

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
      your_id = userSessionData['userId']!;
    });
  }

  Future<void> fetchData() async {
    try {
      //print("Fetching home page data...");
      final friendpageapi =
          await apiService.friend_page_api("xx"); // Fetch data from API

      setState(() {
        users = friendpageapi.users!
            .map((user) => FriendPageModel(
                  name: user.name ?? '',
                  userImage: user.user_image ?? '',
                  id: user.sId ?? '',
                ))
            .toList();
      });

      //print("Data fetched successfully: ${users.length} users found");
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  void onRefresh() {
    // Simulate refreshing the chat list
    print("Refreshing chat list...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OtherPageAppBar(your_title: "Friends"),
      body: users.isEmpty
          ? const Center(
              child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            )) // Show loading indicator if no data
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return FriendsCard(
                    friendPageModel: users[index],
                    your_id: your_id!,
                    onRefresh: onRefresh);
              },
            ),
    );
  }
}
