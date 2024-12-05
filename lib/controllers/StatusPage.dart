import 'package:flutter/material.dart';
import 'package:oiichat/view/StatusPage/AddStatus.dart';
import 'package:oiichat/view/StatusPage/UserStatus.dart';


class Statuspage extends StatelessWidget {
  final String? your_id;
  final String? your_name;
  final String? your_image;

  const Statuspage({super.key, this.your_id, this.your_name, this.your_image});

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
          const SizedBox(height: 13),
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
            AddStatus(
              your_id:your_id,
        your_name: your_name,
        your_image: your_image,
            ),
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Text("Recent Updates"),
              ),
            ),
            const UserStatus(),
            const UserStatus(),
            const UserStatus(),
            Container(
              height: 33,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[300],
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                child: Text("Viewed Updates"),
              ),
            ),
            const UserStatus(),
            const UserStatus(),
            const UserStatus(),
          ],
        ),
      ),
    );
  }
}
