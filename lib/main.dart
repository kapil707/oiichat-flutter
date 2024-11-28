import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:oiichat/RealTimeService.dart';
import 'package:oiichat/api/firebase_api.dart';
import 'package:oiichat/controllers/FriendController.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/controllers/LoginController.dart';
import 'package:oiichat/controllers/MyProfileController.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/controllers/StoriesController.dart';
import 'package:oiichat/splash_screen.dart';
import 'package:oiichat/view/Notification.dart';
import 'package:oiichat/wrapper.dart';


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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade50),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white, // AppBar text color
          backgroundColor: Color.fromARGB(255, 178, 160, 132), // AppBar background color
        ),
        useMaterial3: true,
      ),
//home: RealTimeScreen(),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => const SplashScreenClass(),
        '/LoginPage': (context) => LoginController(),
        '/SingUpPage': (context) => SingUpController(),
        '/HomePage': (context) => HomeController(),
        '/StoriesPage': (context) => StoriesController(),
        '/MyProfilePage': (context) => MyProfileController(),
        '/Notification': (context) => MyNotification(),
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
