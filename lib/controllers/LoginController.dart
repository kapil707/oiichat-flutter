import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/LoginService.dart';
import 'package:oiichat/session.dart';
import 'package:oiichat/widget/main_widget.dart';

class LoginController extends StatefulWidget {
  const LoginController({super.key});

  @override
  State<LoginController> createState() => _LoginControllerState();
}

class _LoginControllerState extends State<LoginController> {
  final apiService = MyApiService(Dio());
  late final LoginService loginService;

  var username = TextEditingController();
  String? usernameError;
  var password = TextEditingController();
  String? passwordError;
  bool _isLoading = false;
  String? mainError;

  @override
  void initState() {
    super.initState();
    loginService = LoginService(apiService);
  }

  Future<void> _handleLogin() async {
    usernameError = "";
    passwordError = "";
    mainError = "";
    if (username.text.isEmpty) {
      usernameError = "Please enter your username.";
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.warning,
          title: "Enter Username",
        ),
      );
    }

    if (password.text.isEmpty) {
      passwordError = "Please enter your password.";
      ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.warning,
          title: "Enter Password",
        ),
      );
    }

    if (username.text.isEmpty || password.text.isEmpty) {
      setState(() {
        mainError = "Please enter username or password.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final loginResponse =
        await loginService.login_api(context, username.text, password.text);

    setState(() {
      _isLoading = false;
      mainError = loginResponse.message;
      if (loginResponse.status == "1") {
        Get.to(HomeController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App logo or Icon
              const Icon(
                Icons.person,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 40),

              // Username/Email Text Field
              MainEmailbox(
                mytextController: username,
              ),
              MainErrorLabel(message: usernameError),
              const SizedBox(height: 20),

              // Password Text Field
              MainPasswordbox(
                mytextController: password,
              ),
              MainErrorLabel(message: passwordError),
              const SizedBox(height: 30),

              if (_isLoading) ...{
                const Center(
                  child: CircularProgressIndicator(),
                ),
              } else ...{
                // Login Button
                MainButton(btnName: 'Login', callBack: _handleLogin),
              },
              MainErrorLabel(message: mainError),
              const SizedBox(height: 20),

              // Register and Forgot Password Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(SingUpController());
                      // Handle register logic here
                    },
                    child: const Text('Create Account'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle forgot password logic here
                    },
                    child: const Text('Forgot Password?'),
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
