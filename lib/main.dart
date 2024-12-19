import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:oiichat/Config/notification.dart';
import 'package:oiichat/controllers/HomeController.dart';
import 'package:oiichat/controllers/UserCall.dart';
import 'package:oiichat/controllers/testcall.dart';
import 'package:oiichat/themes/themeClass.dart';
import 'package:oiichat/view/LandingPage.dart';
import 'package:oiichat/config/RealTimeService.dart';
import 'package:oiichat/config/firebase_api.dart';
import 'package:oiichat/controllers/FriendController.dart';
import 'package:oiichat/controllers/LoginController.dart';
import 'package:oiichat/controllers/MyProfileController.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/view/SplashScreen.dart';
import 'package:oiichat/view/Notification.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//https://javiercbk.github.io/json_to_dart/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // yha call notification ke liya
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully!");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  // await FirebaseMessaging.instance.requestPermission(
  //   announcement: true,
  //   carPlay: false,
  //   criticalAlert: false,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OiiChat',
      theme: lightTheme,
      darkTheme: darkTheme,
      //home: RealTimeScreen(),
      initialRoute: '/',
      navigatorKey: navigatorKey,
      routes: {
        '/': (context) => SplashScreenClass(),
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

class IncomingCallExample extends StatelessWidget {
  const IncomingCallExample({Key? key}) : super(key: key);

  void acceptCall() {
    print('Call Accepted');
    // Navigate to your in-call screen
  }

  void declineCall() {
    print('Call Declined');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return OutGoingCallScreen(
    //   callerName: 'Kapil Sharma',
    //   callerImage:
    //       'https://scontent.fjdh1-2.fna.fbcdn.net/v/t39.30808-1/469531521_2303325946711562_3047562261330012207_n.jpg?stp=dst-jpg_s320x320_tt6&_nc_cat=105&ccb=1-7&_nc_sid=0ecb9b&_nc_ohc=spjJjV8E-TEQ7kNvgECWgio&_nc_zt=24&_nc_ht=scontent.fjdh1-2.fna&_nc_gid=Am37l1FquRocp-DS9f6QMqt&oh=00_AYDovrAVYzZXBkaz3l8UU1oWzm21rYbmalFJtnF4ansIMw&oe=6766C124',
    //   calltype: "Calling...",
    //   onDecline: declineCall,
    // );
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
