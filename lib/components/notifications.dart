import 'package:firebase_messaging/firebase_messaging.dart';

class Noti {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static Future getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();

   await firebaseMessaging.getToken().then((t){if(t!=null){
    
   }});
  }
}
