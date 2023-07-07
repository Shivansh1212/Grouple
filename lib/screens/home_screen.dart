// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import '../components/group_tile.dart';
import '../components/snackbar.dart';
import '../helper/helper_function.dart';
import 'login_screen.dart';
import 'profile_page.dart';
import 'search_screen.dart';
import '../service/auth_service.dart';
import '../service/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String email = '';
  Authservice authservice = Authservice();
  Stream? groups;
  bool showSpinner = false;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  String getId(String x) {
    return x.substring(0, x.indexOf('_'));
  }

  String getName(String x) {
    return x.substring(x.indexOf('_') + 1);
  }
  Future<bool> onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the App?'),
        actions:[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
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
    await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName:
                            getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data['fullName']);
                  },
                );
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.blue,
            ));
          }
        });
  }

  void popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Create a group',
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showSpinner
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      )
                    : TextField(
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text(
                  'CANCEL',
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != '') {
                    setState(() {
                      showSpinner = true;
                    });
                    DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() => showSpinner = false);
                  }
                  Navigator.pop(context);
                  showSnackbar(context, Colors.green, 'group created');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(
                  'CREATE',
                ),
              ),
            ],
          );
        });
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              size: 70,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Add groups to start chatting!! Tap on the add icon to create groups or search groups from the search button',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black87,
          centerTitle: true,
          title: const Text(
            'Groups',
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.id);
              },
              icon: const Icon(
                Icons.search,
                size: 25,
              ),
            ),
          ],
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
                onTap: () {},
                selected: true,
                selectedColor: Colors.black,
                title: Text(
                  'Groups',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                leading: Icon(Icons.group),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ProfilePage.id);
                },
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
        body: groupList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            popUpDialog(context);
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
