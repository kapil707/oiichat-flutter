import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../View/main_widget.dart';
import '../config/retrofit_api.dart';
import '../service/LoginService.dart';

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
  String? _firebaseToken;

  @override
  void initState() {
    super.initState();
    getFirebaseToken();
    loginService = LoginService(apiService);
  }

  Future<void> getFirebaseToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _firebaseToken = token;
      });
      print("Firebase Token: $token");
    } catch (e) {
      print("Error fetching token: $e");
    }
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

    final loginResponse = await loginService.login_api(
        context, username.text, password.text, _firebaseToken!);

    setState(() {
      _isLoading = false;
      mainError = loginResponse.message;
      print("login res:" + loginResponse.message.toString());
      if (loginResponse.status == "1") {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                color: Colors.orange,
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
                      //Get.to(SingUpController());
                      // Handle register logic here
                      Navigator.pushNamed(context, '/SingUpPage');
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
