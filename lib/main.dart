import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/controllers/LoginController.dart';
import 'package:oiichat/controllers/MyProfileController.dart';
import 'package:oiichat/controllers/NotificationController.dart';
import 'package:oiichat/controllers/StoriesController.dart';
import 'package:oiichat/splash_screen.dart';
import 'package:oiichat/wrapper.dart';

//https://javiercbk.github.io/json_to_dart/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
home: Wrapper(),
      /*initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenClass(),
        '/LoginPage': (context) => LoginController(),
        '/HomePage': (context) => HomeController(),
        '/StoriesPage': (context) => StoriesController(),
        '/MyProfilePage': (context) => MyProfileController(),
        '/NotificationPage': (context) => NotificationController(),
      },*/
    );
  }
}