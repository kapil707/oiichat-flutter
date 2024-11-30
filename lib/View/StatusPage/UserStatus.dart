import 'package:flutter/material.dart';

class UserStatus extends StatelessWidget {
  const UserStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: Colors.black,
          ),
        ],
      ),
      title: Text("Kavita"),
      subtitle: Text("Today at,01:27"),
    );
  }
}
