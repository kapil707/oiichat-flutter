import 'package:flutter/material.dart';
import '../Config/session.dart';

class SplashScreenClass extends StatefulWidget {
  const SplashScreenClass({super.key});

  @override
  State<SplashScreenClass> createState() => _SplashScreenClassState();
}

class _SplashScreenClassState extends State<SplashScreenClass> {
  var islogin;
  @override
  void initState() {
    super.initState();
    checkUserLoginState();
    // Timer(const Duration(seconds: 2), () {
    //   checkUserLoginState();
    // });
  }

  checkUserLoginState() async {
    await Shared.getUserSharedPreferences().then((value) async {
      islogin = value;
      if (islogin == true) {
        Navigator.pushReplacementNamed(context, '/HomePage');
      } else {
        Navigator.pushReplacementNamed(context, '/Landingpage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              SizedBox(height: MediaQuery.of(context).size.height / 5),
              
              Image.asset("assets/logo.png",width: 200,height: 200,),const SizedBox(height: 50),
              const Text(
                "Welcome to OiiChat",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 29,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 5),
             
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
