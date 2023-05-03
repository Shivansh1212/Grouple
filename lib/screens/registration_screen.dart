import 'package:flashchat_flutter/constants.dart';
import 'package:flashchat_flutter/helper/helper_function.dart';
import 'package:flashchat_flutter/screens/home_screen.dart';
import 'package:flashchat_flutter/service/auth_service.dart';
import 'package:flashchat_flutter/screens/login_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../components/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email = '';
  String password = '';
  String fullName = '';
  Authservice authservice = Authservice();
  final formKey = GlobalKey<FormState>();

  void register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        showSpinner = true;
      });
      await authservice
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserNameSF(fullName);
          await HelperFunctions.saveUserEmailSF(email);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, HomeScreen.id);
        }
      });
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
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
                        height: 48.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return 'Enter a name!';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              prefixIcon: const Icon(Icons.person),
                              hintText: 'Enter your Name'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.contains('@')) {
                              return null;
                            } else {
                              return 'Wrong email format';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              prefixIcon: const Icon(Icons.email),
                              hintText: 'Enter your Email'),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password must be atleast 6 characters long";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: kTextFieldDecoration.copyWith(
                              prefixIcon: const Icon(Icons.lock),
                              hintText: 'Enter your password'),
                        ),
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      RoundedButton(
                          colour: Colors.blue.shade700,
                          title: 'Register',
                          onPressed: () {
                            register();
                          }),
                      Text.rich(
                        TextSpan(
                            text: "           Already have have an account?   ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            children: [
                              TextSpan(
                                  text: 'Login Now',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, LoginScreen.id);
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
