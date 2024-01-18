import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  //to return current user
  static User get user => auth.currentUser!;

  //to store current user info
  static late ChatUser self;

  //for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        self = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((user) => getSelfInfo());
      }
    });
  }

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

  //for getting all user info without current user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUserInfo() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for updating user info
  static Future<void> updateUserInfo() async {
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'name': self.name, 'about': self.about});
  }

  //for updating user profile pic and storing on firebase storage
  static Future<void> updateUserProfilePic(File file) async {
    //getting extension of image
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Profile data : ${p0.bytesTransferred / 1000} kb');
    });

    //updating image url in user data
    self.image = await ref.getDownloadURL();

    //updating on firestore database
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': self.image});
  }
}
