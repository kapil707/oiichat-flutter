import 'package:flutter/material.dart';
import 'package:oiichat/view/HomePage.dart';
import 'package:oiichat/view/LoginPage.dart';
import 'package:oiichat/splash_screen.dart';
import 'package:oiichat/view/NotificationPage.dart';

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
        '/LoginPage': (context) => LoginPage(),
        '/HomePage': (context) => HomePage(),
        '/NotificationPage': (context) => NotificationPage(),
      },
    );
  }
}