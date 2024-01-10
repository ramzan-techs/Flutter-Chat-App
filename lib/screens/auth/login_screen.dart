import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';

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

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
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
