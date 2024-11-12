import 'package:flutter/material.dart';
import 'package:oiichat/view/home_page.dart';
import 'package:oiichat/view/login_page.dart';
import 'package:oiichat/splash_screen.dart';

//https://javiercbk.github.io/json_to_dart/

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
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenClass(),
        '/login_page': (context) => Login_Page(),
        '/home_page': (context) => Home_Page(),
      },
    );
  }
}