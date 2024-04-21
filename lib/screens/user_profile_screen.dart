import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/apis.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isChanged = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Icon(Icons.person),
                        imageUrl:
                            _isChanged ? APIs.self.image : widget.user.image,
                        errorWidget: (context, url, error) =>
                            Icon(CupertinoIcons.person),
                      ),
                    ),
                    Positioned(
                      //profile change button
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        shape: CircleBorder(),
                        onPressed: () {
                          _showBottomSheet();
                        },
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
                    onSaved: (val) => APIs.self.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      hintText: 'eg. Ramzan',
                      label: Text('Name', style: TextStyle(fontSize: 18)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.5)),
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
                    onSaved: (val) => APIs.self.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
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
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.5)),
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
                        foregroundColor: Colors.white,
                        fixedSize: Size(mq.width * .6, mq.height * .06)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        log('Inside Validator');
                        _formKey.currentState!.save();
                        APIs.updateUserInfo();
                        Dialogs.showSnackBar(
                            context, 'Profile updated successfully!');
                      }
                    },
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
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: StadiumBorder(),
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            //show progress bar
            Dialogs.showProgressBar(context);

            await APIs.updateActiveTime(false);
            await FirebaseAuth.instance.signOut().then((value) async {
              await GoogleSignIn().signOut();
              // for hiding progress bar
              Navigator.pop(context);
              //for poping out home screen form stack
              Navigator.pop(context);

              APIs.auth = FirebaseAuth.instance;
              //for moving to login screen
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            });
          },
          elevation: 2,
          icon: Icon(Icons.logout),
          label: Text('Logout'),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text(
                "Pick Profile Picture",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        log('Image Path : ${image.path}');
                        Dialogs.showProgressBar(context);
                        await APIs.updateUserProfilePic(File(image.path));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Dialogs.showSnackBar(
                            context, 'Pic Updated Scuccessfuly!');
                        setState(() {
                          _isChanged = true;
                        });
                      }
                    },
                    child: Image.asset(
                      'images/gallery.png',
                      height: mq.height * .15,
                      width: mq.width * .25,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        log('Image Path : ${image.path}');
                        Dialogs.showProgressBar(context);
                        await APIs.updateUserProfilePic(File(image.path));
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Dialogs.showSnackBar(
                            context, 'Pic Updated Scuccessfuly!');
                        setState(() {
                          _isChanged = true;
                        });
                      }
                    },
                    child: Image.asset(
                      'images/camera.png',
                      height: mq.height * .15,
                      width: mq.width * .25,
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
