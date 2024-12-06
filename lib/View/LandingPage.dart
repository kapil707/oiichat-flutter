import 'package:flutter/material.dart';
import 'package:oiichat/Config/Colors.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "Welcome to OiiChat",
                style: TextStyle(
                    color: mainLblColor,
                    fontSize: 29,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Image.asset("assets/landingpage.jpg"),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 17),
                    children: [
                      TextSpan(
                        text: "Agree and Continue to accept the",
                        style: TextStyle(color: mainTxtColor),
                      ),
                      const TextSpan(
                        text: " OiiChat Trems of Service and Privacy Policy",
                        style: TextStyle(color: mainLinkColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/LoginPage');
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 55,
                  child: const Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    color: mainBtnColor,
                    child: Center(
                      child: Text(
                        "Agree And Continue",
                        style: TextStyle(color: mainBtnTxtColor, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
