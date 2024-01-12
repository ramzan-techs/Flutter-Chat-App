import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../api/apis.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handleGoogleBtn() {
    //showing progress bar
    Dialogs.showProgressBar(context);

    _signInWithGoogle().then((user) {
      //hiding progress bar
      Navigator.pop(context);

      if (user != null) {
        print("\n user : ${user.user}");
        print("\n user : ${user.additionalUserInfo}");

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      //this funtion by default try to handle exceptio itself
      //and not return exception to return exception
      await InternetAddress.lookup('google.com'); //this will return exception

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print('\n _signInWithGoogle : $e');
      Dialogs.showSnackBar(context, 'Something Went Wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to We Chat"),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              width: mq.width * .5,
              right: _isAnimate ? mq.width * .25 : -mq.width * .5,
              duration: Duration(seconds: 2),
              child: Image.asset('images/app_icon.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width * .9,
              left: mq.width * .05,
              height: mq.height * .07,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 223, 255, 187),
                  elevation: 1,
                ),
                onPressed: () {
                  _handleGoogleBtn();
                },
                icon: Image.asset(
                  'images/google.png',
                  height: mq.height * .05,
                ),
                label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        children: [
                      TextSpan(text: 'Sign In with '),
                      TextSpan(
                          text: 'Google',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20))
                    ])),
              ))
        ],
      ),
    );
  }
}
