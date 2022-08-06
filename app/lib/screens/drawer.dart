import 'dart:ui';
import 'package:app/datastore/data.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Drawer(
        elevation: 2.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: ListView(children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.white),
            currentAccountPicture: const CircleAvatar(
              radius: 50.0,
              backgroundColor: Color(0xFF778899),
              backgroundImage: AssetImage("assets/photo.png"),
            ),
            accountName: Text(
              Data.user,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            accountEmail: null,
          ),
          ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
            title: const Text("Home"),
          ),
           ListTile(
            leading: IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
            title: const Text("Home"),
          ),
        ]),
      ),
    );
  }
}
