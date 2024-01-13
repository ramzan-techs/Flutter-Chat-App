import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/models/chat_user.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .02,
        vertical: 4,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: ListTile(
          //user profile pic
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),

          //user name
          title: Text(widget.user.name),

          //user last message in chat
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),

          //time of last message
          trailing: Text(
            '12:00 PM',
            style: TextStyle(color: Colors.black45),
          ),
        ),
      ),
    );
  }
}
