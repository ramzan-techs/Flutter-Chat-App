import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';

import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/models/message.dart';
import 'package:we_chat/screens/chat_screen_widgets.dart';
import 'package:we_chat/screens/user_profile_view.dart';
import 'package:we_chat/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textEditingController = TextEditingController();
  bool _isEmojiShown = false, _isImageUploading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));
  }

  // to control back button when emoji is shown
  bool _emojiBackLogic() {
    if (_isEmojiShown) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_isEmojiShown)
          setState(() {
            _isEmojiShown = !_isEmojiShown;
          });
      },
      child: PopScope(
        canPop: _emojiBackLogic(),
        onPopInvoked: (didPop) {
          setState(() {
            _isEmojiShown = !_isEmojiShown;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle.light,
            automaticallyImplyLeading: false,
            flexibleSpace: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            UserProfileView(chatUser: widget.user)));
              },
              child: appBar(
                user: widget.user,
              ),
            ),
          ),
          body: Column(children: [
            Expanded(
                child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: SizedBox(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            return MessageCard(
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
            if (_isImageUploading)
              Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ChatInputField(),
            if (_isEmojiShown)
              SizedBox(
                height: mq.height * 0.4,
                child: EmojiPicker(
                  textEditingController: _textEditingController,
                  config: Config(
                    emojiViewConfig: EmojiViewConfig(
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 28 * (Platform.isIOS ? 1.20 : 1.0),
                    ),
                  ),
                ),
              )
          ]),
        ),
      ),
    );
  }

  Widget ChatInputField() {
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
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        _isEmojiShown = !_isEmojiShown;
                      });
                    },
                    icon: Icon(Icons.emoji_emotions),
                    color: Colors.blue,
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (_isEmojiShown)
                          setState(() {
                            _isEmojiShown = !_isEmojiShown;
                          });
                      },
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
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 70);
                        for (var image in images) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _isImageUploading = true;
                          });
                          APIs.sendChatImage(widget.user, File(image.path));
                          setState(() {
                            _isImageUploading = false;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),

                  // image picker from camera
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path : ${image.path}');
                          setState(() {
                            _isImageUploading = true;
                          });
                          APIs.sendChatImage(widget.user, File(image.path));
                          setState(() {
                            _isImageUploading = false;
                          });
                        }
                      },
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
                APIs.sendMessage(
                    widget.user, _textEditingController.text.trim(), Type.text);
                _textEditingController.text = "";
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
