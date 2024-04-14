import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/chat_user.dart';

class appBar extends StatelessWidget {
  final ChatUser user;
  const appBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
        SizedBox(
          width: 4,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .33),
            child: CachedNetworkImage(
              height: mq.width * .12,
              width: mq.width * .12,
              fit: BoxFit.cover,
              placeholder: (context, url) => Icon(Icons.person),
              imageUrl: user.image,
              errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87),
            ),
            Text('Last online seen 12:00AM'),
          ],
        )
      ],
    );
  }
}

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    super.key,
    required this.chatUser,
  });

  final ChatUser chatUser;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    final _textEditingController = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(
          left: mq.width * 0.015,
          right: mq.width * 0.015,
          top: mq.height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              // _currentLines == 1
              //     ? StadiumBorder()
              //     : RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions),
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter message...',
                          hintStyle: TextStyle(color: Colors.blueAccent)),
                    ),
                  ),

                  // image picker from gallery
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),

                  // image picker from camera
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.camera,
                        color: Colors.blue,
                      )),
                  SizedBox(
                    width: 2,
                  )
                ],
              ),
            ),
          ),

          // send message button
          MaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: mq.height * 0.01, horizontal: mq.width * 0.025),
            minWidth: 0,
            onPressed: () {
              if (_textEditingController.text.trim().isNotEmpty) {
                APIs.sendMessage(widget.chatUser, _textEditingController.text);
              }
            },
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 28,
            ),
            shape: CircleBorder(),
            color: Colors.green,
          )
        ],
      ),
    );
  }
}
