// ignore_for_file: use_key_in_widget_constructors
import 'constants.dart';
import 'helper/helper_function.dart';
import './screens/home_screen.dart';
import './screens/profile_page.dart';
import './screens/search_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';
import './screens/login_screen.dart';
import './screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    Grouple(),
  );
}

bool isSignedIn = false;

class Grouple extends StatefulWidget {
  @override
  State<Grouple> createState() => _GroupleState();
}

class _GroupleState extends State<Grouple> {
  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        SearchScreen.id: (context) => const SearchScreen(),
        ProfilePage.id: (context) => const ProfilePage(),
        // chat screen is done differently
      },
      home: isSignedIn ? const HomeScreen() : const WelcomeScreen(),
    );
  }
}
