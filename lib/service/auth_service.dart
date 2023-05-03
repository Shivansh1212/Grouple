// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat_flutter/helper/helper_function.dart';
import 'package:flashchat_flutter/service/database_service.dart';

class Authservice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future loginWithUserNameAndPassword(String email, String password) async {
    try {
      // ignore: unused_local_variable
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerUserWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await DataBaseService(uid: user.uid).savingUserData(fullName, email);
      return true;
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future signout() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserEmailSF('');
      await HelperFunctions.saveUserNameSF('');
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
