import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/controllers/call.dart';
import 'package:oiichat/themes/themeClass.dart';
import 'package:oiichat/View/LandingPage.dart';
import 'package:oiichat/Config/RealTimeService.dart';
import 'package:oiichat/Config/firebase_api.dart';
import 'package:oiichat/controllers/FriendController.dart';
import 'package:oiichat/controllers/LoginController.dart';
import 'package:oiichat/controllers/MyProfileController.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/View/SplashScreen.dart';
import 'package:oiichat/View/Notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//https://javiercbk.github.io/json_to_dart/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully!");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      //home: RealTimeScreen(),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const SplashScreenClass(),
        '/Landingpage': (context) => const Landingpage(),
        '/LoginPage': (context) => const LoginController(),
        '/SingUpPage': (context) => const SingUpController(),
        '/HomePage': (context) => const HomeController(),
        '/MyProfilePage': (context) => const MyProfileController(),
        '/Notification': (context) => const MyNotification(),
        '/MyFriends': (context) => FriendController(),
      },
    );
  }
}

class RealTimeScreen extends StatefulWidget {
  const RealTimeScreen({super.key});

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
      appBar: AppBar(title: const Text("Real-Time Updates")),
      body: Center(
        child: Text("Message from server: $message"),
      ),
    );
  }
}
