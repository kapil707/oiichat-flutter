import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/AppDrawer.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/retrofit_api.dart';
import 'package:oiichat/service/HomeService.dart';

class StoriesController extends StatefulWidget {
  const StoriesController({super.key});

  @override
  State<StoriesController> createState() => _StoriesControllerState();
}

class _StoriesControllerState extends State<StoriesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stories"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.person))],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
                itemCount: 6,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
