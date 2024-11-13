
import 'package:flutter/material.dart';
import 'package:oiichat/session.dart';

class MyDrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MyDrawerTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
      child: SafeArea(child: 
      Padding(padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Icon(Icons.person,size: 80,),
          ),
          
          Divider(
            color: Colors.black,
          ),

          MyDrawerTile(
            title: "Home",
            icon: Icons.home,
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/HomePage'
            );
            },
          ),

          MyDrawerTile(
            title: "Edit Profile",
            icon: Icons.edit,
            onTap: () {
              Navigator.pushReplacementNamed(
                context,
                '/MyProfilePage'
            );
            },
          ),

          MyDrawerTile(
            title: "My Friends",
            icon: Icons.ice_skating,
            onTap: () {
            },
          ),

          MyDrawerTile(
            title: "Friends Request",
            icon: Icons.ice_skating,
            onTap: () {
            },
          ),

          MyDrawerTile(
            title: "Story",
            icon: Icons.ice_skating,
            onTap: () {
               Navigator.pushReplacementNamed(
                context,
                '/StoriesPage'
            );
            },
          ),

          Spacer(),

          MyDrawerTile(
            title: "Logout",
            icon: Icons.logout,
            onTap: () {
              Shared.logout();
              Navigator.pushReplacementNamed(
                context,
                '/'
            );
            },
          )
        ],
      ),
      ),)
    );
  }
}