import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:we_chat/api/apis.dart';

import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/user_profile_screen.dart';

import '../main.dart';
import '../widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.red));
    APIs.getSelfInfo();

    // for updating online status when app starts
    APIs.updateActiveTime(true);

    // checking lifecycle when app goes in background
    // resumed --> again comes online screen opens
    // paused --> screen is goes in background

    SystemChannels.lifecycle.setMessageHandler((message) {
      log(message.toString());
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('paused')) APIs.updateActiveTime(false);
        if (message.toString().contains('resumed')) APIs.updateActiveTime(true);
      }
      return Future.value(message);
    });
  }

  bool _searchingBackLogic() {
    if (_isSearching) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //to hide keyboard when user tap on any point on screen
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        // if searching is on and user press back searching should be cancelled
        // and if searching is not on then app should close
        canPop: _searchingBackLogic(),
        onPopInvoked: (didPop) {
          setState(() {
            _isSearching = !_isSearching;
          });
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search by Name,Email...',
                      hintStyle: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0.5,
                          overflow: TextOverflow.ellipsis),
                      hintMaxLines: 1,
                    ),
                    autofocus: true,
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    })
                : Text("We Chat"),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching ? Icons.cancel : Icons.search)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                UserProfileScreen(user: APIs.self)));
                  },
                  icon: Icon(Icons.more_vert)),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () async {},
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUserInfo(),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  // if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  //if all or some data is loaded show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list = data
                            ?.map((e) => ChatUser.fromJson(e.data()))
                            .toList() ??
                        [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          itemCount:
                              _isSearching ? _searchList.length : _list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                              user: _isSearching
                                  ? _searchList[index]
                                  : _list[index],
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                          'No Chat Found!',
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              })),
        ),
      ),
    );
  }
}
