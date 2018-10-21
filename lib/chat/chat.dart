import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:up4/chat/chatMessagesList.dart';
import 'package:up4/chat/chatInput.dart';
import 'package:up4/services/userBloc.dart';

class Chat extends StatefulWidget {
  final String channelId;
  final String title;

  const Chat({this.channelId, this.title});

  @override
  _ChatState createState() =>
      _ChatState();
}

class _ChatState extends State<Chat> {
  CollectionReference thread;


  @override
  void initState() {
    super.initState();

    thread = Firestore.instance
        .collection('channels')
        .document(widget.channelId)
        .collection('thread');
  }

  @override
  Widget build(BuildContext context) {
    final user = UserWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              user.logout();
              Navigator.of(context).popAndPushNamed('login');
            },
            icon: Icon(
              Icons.input,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: user.userSubject,
              builder: (BuildContext context, AsyncSnapshot<User> user) =>
                  ChatMessagesList(channelId: widget.channelId, user: user),
            ),
          ),
          Container(
            child: ChatInput(
              thread: thread,
            ),
          ),
        ],
      ),
    );
  }
}
