import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/auth/login_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final ChatUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: mq.width,
              height: 30,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .33),
                  child: CachedNetworkImage(
                    height: mq.width * .4,
                    width: mq.width * .4,
                    fit: BoxFit.fill,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        Icon(CupertinoIcons.person),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: MaterialButton(
                    shape: CircleBorder(),
                    onPressed: () {},
                    color: Colors.white,
                    child: Icon(Icons.edit),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.user.email,
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(
              height: mq.height * .05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                  hintText: 'eg. Ramzan',
                  label: Text('Name', style: TextStyle(fontSize: 18)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                initialValue: widget.user.name,
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.info,
                    color: Colors.blue,
                  ),
                  hintText: 'eg. Feeling Happy!',
                  label: Text(
                    'About',
                    style: TextStyle(fontSize: 18),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.5)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                initialValue: widget.user.about,
              ),
            ),
            SizedBox(
              height: mq.height * .07,
            ),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    fixedSize: Size(mq.width * .4, mq.height * .06)),
                onPressed: () {},
                icon: Icon(
                  Icons.update,
                  size: 35,
                ),
                label: Text(
                  'Update',
                  style: TextStyle(fontSize: 20),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        shape: StadiumBorder(),
        backgroundColor: Colors.redAccent,
        onPressed: () async {
          //show progress bar
          Dialogs.showProgressBar(context);
          await FirebaseAuth.instance.signOut().then((value) async {
            await GoogleSignIn().signOut();
            // for hiding progress bar
            Navigator.pop(context);
            //for poping out home screen form stack
            Navigator.pop(context);
            //for moving to login screen
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => LoginScreen()));
          });
        },
        elevation: 2,
        icon: Icon(Icons.logout),
        label: Text('Logout'),
        isExtended: true,
      ),
    );
  }
}
