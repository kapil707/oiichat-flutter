import 'package:flutter/material.dart';
import 'package:oiichat/config/main_config.dart';
import 'package:oiichat/config/session.dart';

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
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}

class AppDrawer extends StatefulWidget {
  final String? your_id;
  final String? your_name;
  final String? your_image;

  const AppDrawer(
      {super.key,
      required this.your_id,
      this.your_name,
      required this.your_image});

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
      backgroundColor: const Color.fromARGB(255, 94, 55, 51),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Profile Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.your_image ?? ""),
                    radius: 30,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.your_name ?? "Loading...",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Your Status Here",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.white,
              ),
              // Drawer Tiles
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
                  Navigator.pushNamed(context, '/MyProfilePage');
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
                icon: Icons.group_add,
                onTap: () {},
              ),
              MyDrawerTile(
                title: "Story",
                icon: Icons.auto_stories,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
