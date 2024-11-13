import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';
import 'package:oiichat/view/MyProfilePage.dart';

class MyProfileController extends StatefulWidget {
  @override
  State<MyProfileController> createState() => _MyProfileControllerState();
}

class _MyProfileControllerState extends State<MyProfileController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
          actions: [
            IconButton(onPressed: (){}, 
            icon: Icon(Icons.person))
          ],
      ),drawer: AppDrawer(),
      body: MyProfilePage(),
    );
  }
}