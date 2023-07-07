// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'home_screen.dart';
import 'login_screen.dart';
import '../service/auth_service.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';

class ProfilePage extends StatefulWidget {
  static const String id = 'profile_page';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = '';
  String email = '';
  Authservice authservice = Authservice();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  void gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 0,
        title: const Text('Profile',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade300,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle, color: Colors.black87, size: 150),
            const SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              email,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 25,
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
              title: Text(
                'Groups',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              leading: Icon(Icons.group),
            ),
            ListTile(
              onTap: () {},
              selected: true,
              selectedColor: Colors.black,
              title: Text(
                'Profile',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              leading: Icon(Icons.group),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.cancel, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authservice.signout().whenComplete(() =>
                                  Navigator.pushNamed(context, LoginScreen.id));
                            },
                            icon: Icon(Icons.done, color: Colors.green),
                          ),
                        ],
                      );
                    });
              },
              selectedColor: Colors.grey,
              title: Text(
                'Log Out',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              leading: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle, size: 200),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name- ', style: TextStyle(fontSize: 17)),
                Text(userName, style: TextStyle(fontSize: 17)),
              ],
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Email- ', style: TextStyle(fontSize: 17)),
                Text(email, style: TextStyle(fontSize: 17)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
