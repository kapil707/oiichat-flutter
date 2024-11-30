import 'package:flutter/material.dart';

import '../view/StatusPage/AddStatus.dart';
import '../view/StatusPage/UserStatus.dart';

class Statuspage extends StatelessWidget {
  const Statuspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[100],
            elevation: 8,
            onPressed: () {},
            child: Icon(Icons.edit, color: Colors.blueGrey[900]),
          ),
          SizedBox(height: 13),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[100],
            elevation: 8,
            onPressed: () {},
            child: Icon(Icons.camera_alt, color: Colors.blueGrey[900]),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AddStatus(),
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Text("Recent Updates"),
              ),
            ),
            UserStatus(),
            UserStatus(),
            UserStatus(),
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Text("Viewed Updates"),
              ),
            ),
            UserStatus(),
            UserStatus(),
            UserStatus(),
          ],
        ),
      ),
    );
  }
}
