import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:we_chat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //to return current user
  static User get user => auth.currentUser!;

  //to check is user exist or not?
  static Future<bool> userExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //to create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey! I am using We Chat",
        createdAt: time,
        lastActive: time,
        isOnline: false,
        id: user.uid,
        email: user.email.toString(),
        pushToken: "");

    await firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }
}
