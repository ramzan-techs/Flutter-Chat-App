import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:we_chat/api/apis.dart';

import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/chat_screen_widgets.dart';
import 'package:we_chat/widgets/chat_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.blue, statusBarBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: appBar(
            user: widget.user,
          ),
        ),
        body: Column(children: [
          Expanded(
              child: StreamBuilder(
            stream: APIs.getAllMessages(),
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  log('Message : ${jsonEncode(data![0].data())}');
                  // _list = data
                  //         .map((e) => ChatUser.fromJson(e.data()))
                  //         .toList() ??
                  //     [];
                  _list.clear();
                  _list = [
                    Message(
                        toId: 'xyz',
                        read: "12:00",
                        type: Type.text,
                        sent: '12:00',
                        fromId: APIs.user.uid,
                        msg: "Hello"),
                    Message(
                        toId: APIs.user.uid,
                        read: "12:00",
                        type: Type.text,
                        sent: '12:00',
                        fromId: "zyx",
                        msg: "Hello2")
                  ];

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return ChatCard(
                            message: _list[index],
                          );
                        });
                  } else {
                    return Center(
                      child: Text(
                        'Say Hii👋!',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
              }
            }),
          )),
          ChatInputField()
        ]),
      ),
    );
  }
}
