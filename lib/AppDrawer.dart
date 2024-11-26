import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/main_functions.dart';
import 'package:oiichat/session.dart';
import 'package:oiichat/splash_screen.dart';

class MyDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MyDrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class AppDrawer extends StatefulWidget {

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  
  String? _display_name;

  @override
  void initState() {
    super.initState();
    _handlePageLoad();
  }

  Future<void> _handlePageLoad() async {
    UserSession userSession = UserSession();
      Map<String, String> userSessionData = await userSession.GetUserSession();
      setState(() {
        _display_name = userSessionData['userName']!;
      });
  }

  singOut(context) async {
    //await FirebaseAuth.instance.signOut();
    Shared.logout();
    //Get.to(const SplashScreenClass());
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.orange.shade50,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 80,
                      ),
                      Text(_display_name ?? "Loading..."),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.black,
                ),
                MyDrawerTile(
                  title: "Home",
                  icon: Icons.home,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/HomePage');
                  },
                ),
                MyDrawerTile(
                  title: "Edit Profile",
                  icon: Icons.edit,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/MyProfilePage');
                  },
                ),
                MyDrawerTile(
                  title: "My Friends",
                  icon: Icons.ice_skating,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/MyFriends');
                  },
                ),
                MyDrawerTile(
                  title: "Friends Request",
                  icon: Icons.ice_skating,
                  onTap: () {},
                ),
                MyDrawerTile(
                  title: "Story",
                  icon: Icons.ice_skating,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/StoriesPage');
                  },
                ),
                const Spacer(),
                MyDrawerTile(
                  title: "Logout",
                  icon: Icons.logout,
                  onTap: () {
                    singOut(context);
                  },
                )
              ],
            ),
          ),
        ));
  }
}
