import 'package:flutter/material.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Welcome to OiiChat",
                style: TextStyle(
                    color: Colors.orange,
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
                    style: TextStyle(color: Colors.black, fontSize: 17),
                    children: [
                      TextSpan(
                        text: "Agree and Continue to accept the",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      TextSpan(
                        text: " OiiChat Trems of Service and Privacy Policy",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/LoginPage');
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 110,
                  height: 55,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 8,
                    color: Colors.orange,
                    child: Center(
                      child: Text(
                        "Agree And Continue",
                        style: TextStyle(color: Colors.white, fontSize: 20),
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
