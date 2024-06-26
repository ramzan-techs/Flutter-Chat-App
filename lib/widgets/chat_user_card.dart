import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/chat_screen.dart';

import '../main.dart';
import 'dialogs/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
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
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
          stream: APIs.getLastMessages(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              //user profile pic
              leading: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => ProfileDialog(
                            user: widget.user,
                          ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .3),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    height: mq.height * .055,
                    width: mq.height * .055,
                    placeholder: (context, url) => Icon(Icons.person),
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
              ),

              //user name
              title: Text(widget.user.name),

              //user last message in chat
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_message != null)
                    _message!.fromId != APIs.user.uid
                        ? SizedBox()
                        : _message!.read.isEmpty
                            ? Icon(
                                Icons.done_all_rounded,
                                size: 18,
                              )
                            : Icon(
                                Icons.done_all_rounded,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                  _message != null
                      ? _message!.type == Type.text
                          ? Text(
                              _message!.msg.length > 30
                                  ? _message!.msg.substring(0, 30) + '...'
                                  : _message!.msg,
                            )
                          : Text("Image")
                      : Text("No Chat Found!"),
                ],
              ),

              //time of last message
              trailing: _message == null
                  ? null
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10)),
                        )
                      : Text(
                          MyDateUtil.getLastMessageTime(
                              context: context, time: _message!.sent),
                          style: TextStyle(color: Colors.black45),
                        ),
            );
          },
        ),
      ),
    );
  }
}
