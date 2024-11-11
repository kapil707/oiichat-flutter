import 'package:flutter/material.dart';
import 'package:oiichat/view/login.dart';
import 'package:oiichat/widget/main_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      appBarTheme: AppBarTheme(
        foregroundColor: Colors.white, // AppBar text color
        backgroundColor: Colors.deepPurple, // AppBar background color
      ),
  useMaterial3: true,
),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("jai mata di"),
      ),
      body: Text("jai shree ram"),
    );
  }
}

