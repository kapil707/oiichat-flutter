import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/Colors.dart';
import '../view/main_widget.dart';
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
      print("Firebase Token : $token");
    } catch (e) {
      print("Firebase Token Error fetching: $e");
    }
  }

  Future<void> _handleGoogle() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential result = await firebaseAuth.signInWithCredential(credential);

    User? userdetails = result.user;
    if (result != null) {
      Map<String, dynamic> userInfoMap = {
        "email": userdetails!.email,
        "name": userdetails.displayName,
        "image": userdetails.photoURL,
        "id": userdetails.uid,
      };
      print(userInfoMap);

      // String uid = userdetails!.uid;
      // String? name = userdetails.displayName;
      // String? email = userdetails.email;
      // String? image = userdetails.photoURL;

      // final loginResponse = await loginService.registerUserOrLoginUser(
      //     context, uid, "google", name!, email!, image!, _firebaseToken!);

      // setState(() {
      //   _isLoading = false;
      //   mainError = loginResponse.message;
      //   print("login res:${loginResponse.message}");
      //   if (loginResponse.status == "1") {
      //     Navigator.pushReplacementNamed(context, '/');
      //   }
      // });
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
      print("login res:${loginResponse.message}");
      if (loginResponse.status == "1") {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OiiChat"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // App logo or Icon
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Welcome to OiiChat Login",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                // Username/Email Text Field

                Text(
                  "Enter Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                MainEmailbox(
                  mytextController: username,
                ),
                MainErrorLabel(message: usernameError),
                const SizedBox(height: 20),

                // Password Text Field
                Text(
                  "Enter Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
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

                MainButton(
                    btnName: 'Login With Google', callBack: _handleGoogle),

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
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: mainLinkColor, fontSize: 16),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle forgot password logic here
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(color: mainLinkColor, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
