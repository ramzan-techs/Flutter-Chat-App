import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/models/chat_user.dart';

import '../main.dart';

class UserProfileView extends StatelessWidget {
  final ChatUser chatUser;
  const UserProfileView({super.key, required this.chatUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatUser.name),
      ),
      body: Column(
        children: [
          SizedBox(
            width: mq.width,
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .33),
            child: CachedNetworkImage(
              height: mq.width * .4,
              width: mq.width * .4,
              fit: BoxFit.cover,
              placeholder: (context, url) => Icon(Icons.person),
              imageUrl: chatUser.image,
              errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            chatUser.email,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          SizedBox(
            height: mq.height * .05,
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(8),
              width: mq.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(chatUser.about)
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Joined on:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              "${MyDateUtil.getformattedDate(context: context, time: chatUser.createdAt, showDate: true)}",
              style: TextStyle(fontSize: 18, color: Colors.black45),
            ),
          ]),
    );
  }
}
