import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date_util.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/models/message.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId ? _greenMsg() : _blueMsg();
  }

  Widget _greenMsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
              padding: EdgeInsets.only(
                  top: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                  left: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                  right: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                  bottom:
                      widget.message.type == Type.text ? mq.width * 0.03 : 4),
              margin: EdgeInsets.only(
                  top: mq.width * 0.03,
                  right: mq.width * 0.04,
                  left: mq.width * 0.2),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 145, 225, 167),
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
              child: widget.message.type == Type.text
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Text(
                            widget.message.msg,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MyDateUtil.getformattedDate(
                                  context: context, time: widget.message.sent),
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            widget.message.read.isEmpty
                                ? Icon(
                                    Icons.done_all_rounded,
                                    size: 15,
                                  )
                                : Icon(
                                    Icons.done_all_rounded,
                                    size: 15,
                                    color: Colors.blue,
                                  )
                          ],
                        ),
                      ],
                    )
                  :
                  // if image is the message
                  Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            placeholder: (context, url) {
                              return Padding(
                                padding: EdgeInsets.all(30),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            imageUrl: widget.message.msg,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.image),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 30,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                ),
                              ),
                            )),
                        Positioned(
                          bottom: 4,
                          right: 10,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                MyDateUtil.getformattedDate(
                                    context: context,
                                    time: widget.message.sent),
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              widget.message.read.isEmpty
                                  ? Icon(
                                      Icons.done_all_rounded,
                                      size: 17,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.done_all_rounded,
                                      size: 17,
                                      color: Colors.blue,
                                    )
                            ],
                          ),
                        ),
                      ],
                    )),
        ),
      ],
    );
  }

  Widget _blueMsg() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.only(
                top: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                left: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                right: widget.message.type == Type.text ? mq.width * 0.03 : 4,
                bottom: widget.message.type == Type.text ? mq.width * 0.03 : 4),
            margin: EdgeInsets.only(
                top: mq.width * 0.03,
                bottom: mq.width * 0.03,
                left: mq.width * 0.04,
                right: mq.width * 0.2),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 208, 223, 234),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            child: widget.message.type == Type.text
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          widget.message.msg,
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            MyDateUtil.getformattedDate(
                                context: context, time: widget.message.sent),
                            style: TextStyle(fontSize: 10),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          widget.message.read.isEmpty
                              ? Icon(
                                  Icons.done_all_rounded,
                                  size: 15,
                                )
                              : Icon(
                                  Icons.done_all_rounded,
                                  size: 15,
                                  color: Colors.blue,
                                )
                        ],
                      ),
                    ],
                  )
                :
                // if image is the message
                Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                          placeholder: (context, url) {
                            return Padding(
                              padding: EdgeInsets.all(30),
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            );
                          },
                          imageUrl: widget.message.msg,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image),
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 30,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                              ),
                            ),
                          )),
                      Positioned(
                        bottom: 4,
                        right: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MyDateUtil.getformattedDate(
                                  context: context, time: widget.message.sent),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            widget.message.read.isEmpty
                                ? Icon(
                                    Icons.done_all_rounded,
                                    size: 17,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.done_all_rounded,
                                    size: 17,
                                    color: Colors.blue,
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
