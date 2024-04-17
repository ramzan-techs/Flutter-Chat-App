import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
