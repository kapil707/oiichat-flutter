import 'package:flutter/material.dart';
import 'package:oiichat/widget/main_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var username = TextEditingController();
  var password = TextEditingController();

  void _functionLogin(_context, String _username, String _password) async {
      print(_username);
      print(_password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
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
              
              // Username/Email Text Field
              MainEmailbox(mytextController: username,),
              SizedBox(height: 20),
              
              // Password Text Field
              MainPasswordbox(mytextController: password,),
              SizedBox(height: 30),
              
              // Login Button
              MainButton(btnName: 'Login',callBack: (){
                 String _username = username.text.toString();
                String _password = password.text.toString();
                _functionLogin(context, _username, _password);
              },),
              SizedBox(height: 20),
              
              // Register and Forgot Password Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle register logic here
                    },
                    child: Text('Create Account'),
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