import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/controllers/ChatRoomController.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';
import 'package:oiichat/widget/main_widget.dart';

class HomeController extends StatefulWidget {
  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  final RealTimeService _realTimeService = RealTimeService();
  List<Map<String, dynamic>> users = []; // Store users list

  String? user1;
  
  final apiService = MyApiService(Dio());
  late final HomeService homeService;
   @override
  void initState() {
    super.initState();
    _handlePageLoad();
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }

  Future<void> _handlePageLoad() async {
    
    UserSession userSession = UserSession();
    Map<String, String> userSessionData = await userSession.GetUserSession();
    setState(() {
      user1 = userSessionData['userId']!;
    });
  }

  void chatroom(){
    Get.to(ChatRoomController(user1:user1,user2: '6735b919c9b5f0da9da5fb9a'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
          actions: [
            IconButton(onPressed: (){}, 
            icon: Icon(Icons.person))
          ],
      ),drawer: AppDrawer(),
      body:
      MainButton(btnName: 'Login',callBack: chatroom)
       /*Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (users.isEmpty)
              Center(child: CircularProgressIndicator()) // Loading indicator
            else
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                      onTap: () => {
                        //print('${user1}')
                        Get.to(ChatRoomController(user1:user1,user2: user['_id'],))
                      }
                    );
                  },
                ),
              ),
          ],
        ),
      ),*/
    );
  }
}