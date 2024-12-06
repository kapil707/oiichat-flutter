import 'package:flutter/material.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/view/main_widget.dart';

class SingUpController extends StatefulWidget {
  const SingUpController({super.key});

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
  final bool _isLoading = false;
  String? mainError;

  @override
  void initState() {
    super.initState();
    //_realTimeService.initSocket();
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }

  singUp() async {
    /*_realTimeService.addUser(
      name.text,
      username.text,
      password.text,
    );*/
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
                    "Welcome to OiiChat SingUp",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),

                Text(
                  "Enter Name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                MainTextboxWithIcon(
                    mytextController: name,
                    btnIcon: const Icon(Icons.person),
                    btnName: 'Name',
                    btnNamehint: 'Enter your name'),
                MainErrorLabel(message: nameError),
                const SizedBox(height: 20),

                Text(
                  "Enter Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                // Username/Email Text Field
                MainEmailbox(
                  mytextController: username,
                ),
                MainErrorLabel(message: usernameError),
                const SizedBox(height: 20),

                Text(
                  "Enter Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                  MainButton(btnName: 'SingUp', callBack: singUp),
                },
                MainErrorLabel(message: mainError),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
