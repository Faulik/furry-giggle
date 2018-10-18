import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:up4/chat/chatMessagesList.dart';
import 'package:up4/chat/chatInput.dart';
import 'package:up4/userBloc.dart';

class Chat extends StatefulWidget {
  final String channelId;
  final String title;

  const Chat({this.channelId, this.title});

  @override
  _ChatState createState() =>
      _ChatState(channelId: this.channelId, title: this.title);
}

class _ChatState extends State<Chat> {
  final String channelId;
  final String title;
  CollectionReference thread;

  _ChatState({this.channelId, this.title}) {
    thread = Firestore.instance
        .collection('channels')
        .document(channelId)
        .collection('thread');
  }

  @override
  Widget build(BuildContext context) {
    final user = UserWidget.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: user.userSubject,
              builder: (BuildContext context, AsyncSnapshot<User> user) =>
                  ChatMessagesList(channelId: channelId, user: user),
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
