import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_util.dart';

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
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return StreamBuilder(
      stream: APIs.getUserInfo(user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list = data
                ?.map(
                  (e) => ChatUser.fromJson(e.data()),
                )
                .toList() ??
            [];

        return Column(
          children: [
            SizedBox(
              height: statusBarHeight,
            ),
            Row(
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
                      imageUrl: list.isNotEmpty ? list[0].image : user.image,
                      errorWidget: (context, url, error) =>
                          Icon(CupertinoIcons.person),
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
                      list.isNotEmpty ? list[0].name : user.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),
                    ),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                              ? "Online"
                              : MyDateUtil.getLastActiveTime(
                                  context: context,
                                  lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                              context: context, lastActive: user.lastActive),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
