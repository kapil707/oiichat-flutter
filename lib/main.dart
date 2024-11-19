import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/controllers/FriendController.dart';
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
//home: RealTimeScreen(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenClass(),
        '/LoginPage': (context) => LoginController(),
        '/HomePage': (context) => HomeController(),
        '/StoriesPage': (context) => StoriesController(),
        '/MyProfilePage': (context) => MyProfileController(),
        '/NotificationPage': (context) => NotificationController(),
        '/MyFriends': (context) => FriendController(),
      },
    );
  }
}

class RealTimeScreen extends StatefulWidget {
  @override
  _RealTimeScreenState createState() => _RealTimeScreenState();
}

class _RealTimeScreenState extends State<RealTimeScreen> {
  final RealTimeService _realTimeService = RealTimeService();
  String message = '';

  @override
  void initState() {
    super.initState();
    //_realTimeService.initSocket();

    _realTimeService.socket.on('server_update', (data) {
      setState(() {
        message = data['message'];
      });
    });
  }

  @override
  void dispose() {
    _realTimeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Real-Time Updates")),
      body: Center(
        child: Text("Message from server: $message"),
      ),
    );
  }
}