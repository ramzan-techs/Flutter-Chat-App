import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      // setting screen back to edge to edge means show status bar
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      // navigating to home screen
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              width: mq.width * .5,
              right: mq.width * .25,
              child: Image.asset('images/app_icon.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                'Made By Ramzan Techs❤️',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
