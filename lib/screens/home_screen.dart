import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        builder: (_) => UserProfileScreen(user: APIs.self)));
              },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await GoogleSignIn().signOut();
          },
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
                _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];

                if (_list.isNotEmpty) {
                  return ListView.builder(
                      padding: EdgeInsets.only(top: mq.height * 0.01),
                      itemCount:
                          _isSearching ? _searchList.length : _list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user:
                              _isSearching ? _searchList[index] : _list[index],
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
    );
  }
}
