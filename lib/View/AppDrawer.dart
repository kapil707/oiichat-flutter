import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:oiichat/Config/main_config.dart';
import 'package:oiichat/controllers/SingUpController.dart';
import 'package:oiichat/Config/main_functions.dart';
import 'package:oiichat/View/SplashScreen.dart';

import '../Config/session.dart';

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
  final String? user_name;
  final String? user_image;

  const AppDrawer(
      {super.key, required this.user_name, required this.user_image});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (widget.user_image != "") ...{
                        CircleAvatar(
                            backgroundImage: NetworkImage(
                                MainConfig.image_url + widget.user_image!)),
                      },
                      Text(widget.user_name ?? "Loading..."),
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
                  icon: Icons.contact_page,
                  onTap: () {
                    Navigator.pushNamed(context, '/MyFriends');
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
