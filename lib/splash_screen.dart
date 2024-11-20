import 'package:flutter/material.dart';
import 'package:oiichat/session.dart';

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
        Navigator.pushReplacementNamed(context, '/LoginPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/images/logo4.png',
              width: 100,
            ),
            Container(height: 11),
            const Text(
              'D.R. Distributor',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const CircularProgressIndicator(),
            Container(height: 100),
            const Center(
              child: Text(
                "D R Distributors Pvt Ltd",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const Center(
              child: Text(
                "Website version 44",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Container(height: 100),
          ],
        ),
      ),
    );
  }
}
