import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';

import '../../screens/user_profile_view.dart';

class ProfileDialog extends StatelessWidget {
  final ChatUser user;
  const ProfileDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      content: SizedBox(
        height: mq.height * 0.3,
        width: mq.width * 0.6,
        child: Stack(children: [
          Positioned(
            top: mq.height * 0.055,
            left: mq.width * 0.09,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(mq.height * .33),
              child: CachedNetworkImage(
                height: mq.width * .5,
                width: mq.width * .5,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(Icons.person),
                imageUrl: user.image,
                errorWidget: (context, url, error) =>
                    Icon(CupertinoIcons.person),
              ),
            ),
          ),
          Positioned(
              top: mq.height * 0.015,
              left: mq.width * 0.04,
              width: mq.width * 0.5,
              child: Text(
                user.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              )),
          Positioned(
              top: 1,
              right: 1,
              child: MaterialButton(
                minWidth: 0,
                shape: CircleBorder(),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UserProfileView(
                                chatUser: user,
                              )));
                },
                child: Icon(
                  Icons.info_outline,
                  size: 30,
                ),
              ))
        ]),
      ),
    );
  }
}
