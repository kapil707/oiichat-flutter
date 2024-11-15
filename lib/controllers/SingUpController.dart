import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_responsive.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/controllers/LoginController.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/LoginService.dart';
import 'package:oiichat/widget/main_widget.dart';
import 'package:oiichat/wrapper.dart';

class SingUpController extends StatefulWidget {
  @override
  State<SingUpController> createState() => _SingUpControllerState();
}

class _SingUpControllerState extends State<SingUpController> {

  final RealTimeService _realTimeService = RealTimeService();

  var name = TextEditingController();
  String? nameError;
  var username = TextEditingController();
  String? usernameError;
  var password = TextEditingController();
  String? passwordError;
  bool _isLoading = false;
  String? mainError;

  @override
  void initState() {
    super.initState();
    _realTimeService.initSocket();
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }

  singUp()async{
    _realTimeService.addUser(
      name.text,
      username.text,
      password.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SingUp Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App logo or Icon
              Icon(
                Icons.person,
                size: 80,
                color: Colors.deepPurple,
              ),
              SizedBox(height: 40),
              

              MainTextboxWithIcon(mytextController: name,btnIcon: Icon(Icons.person) ,btnName:'Name'),
              MainErrorLabel(message:nameError),
              SizedBox(height: 20),

              // Username/Email Text Field
              MainEmailbox(mytextController: username,),
              MainErrorLabel(message:usernameError),
              SizedBox(height: 20),
              
              // Password Text Field
              MainPasswordbox(mytextController: password,),MainErrorLabel(message:passwordError),
              SizedBox(height: 30),

              if (_isLoading)...{
                  Center(
                    child: CircularProgressIndicator(),
                ),
              }else...{              
                // Login Button
                MainButton(btnName: 'singUp',callBack: singUp),
              },
              MainErrorLabel(message:mainError),
              SizedBox(height: 20),
              
              // Register and Forgot Password Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle register logic here
                      Get.to(LoginController());
                    },
                    child: Text('Login Account'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password logic here
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}