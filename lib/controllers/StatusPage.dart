import 'package:flutter/material.dart';

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
            onPressed: (){},
            child: Icon(Icons.edit,color: Colors.blueGrey[900]),
          ),
          SizedBox(height: 13),
          FloatingActionButton(
            backgroundColor: Colors.blueGrey[100],
            elevation: 8,
            onPressed: (){},
            child: Icon(Icons.camera_alt,color: Colors.blueGrey[900]),
          )
        ],
      ),
    );
  }
}