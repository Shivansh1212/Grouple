import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_flutter/components/rounded_button.dart';
import 'package:flashchat_flutter/constants.dart';
import 'package:flashchat_flutter/screens/home_screen.dart';
import 'package:flashchat_flutter/screens/registration_screen.dart';
import 'package:flashchat_flutter/screens/welcome_screen.dart';
import 'package:flashchat_flutter/service/auth_service.dart';
import 'package:flashchat_flutter/service/database_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../helper/helper_function.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  // final _auth = FirebaseAuth.instance;
  Authservice authservice = Authservice();
  final formKey = GlobalKey<FormState>();

  void login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      await authservice
          .loginWithUserNameAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DataBaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, HomeScreen.id);
        } else {
          setState(() {
            showSpinner = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, WelcomeScreen.id);
          },
        ),
        backgroundColor: Colors.black87,
      ),
      // backgroundColor: const Color.fromARGB(255, 55, 48, 48),
      body: showSpinner
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : Material(
              color: const Color.fromARGB(255, 68, 60, 60),
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        child: Hero(
                          tag: 'logo',
                          child: SizedBox(
                            height: 180.0,
                            child: Image.asset('images/appicon.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 45.0,
                      ),
                      Column(
                        children: [
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.email),
                                  hintText: 'Enter your Email'),
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(30),
                            child: TextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              onChanged: (value) {
                                password = value;
                              },
                              decoration: kTextFieldDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'Enter your password'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                          colour: Colors.lightBlueAccent.shade700,
                          title: 'Log In',
                          onPressed: () {
                            login();
                          }),
                      const SizedBox(
                        height: 15,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "           Don't have an account?   ",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                  text: 'Register Now',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, RegistrationScreen.id);
                                    })
                            ]),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
