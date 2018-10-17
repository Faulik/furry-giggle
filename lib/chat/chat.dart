import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:up4/chat/chatMessagesList.dart';
import 'package:up4/chat/chatInput.dart';
import 'package:up4/userBloc.dart';

class Chat extends StatefulWidget {
  final String channelId;

  const Chat({this.channelId});

  @override
  _ChatState createState() => _ChatState(channelId: this.channelId);
}

class _ChatState extends State<Chat> {
  final String channelId;
  CollectionReference thread;

  _ChatState({this.channelId}) {
    thread = Firestore.instance
        .collection('channels')
        .document(channelId)
        .collection('thread');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(channelId),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChatMessagesList(channelId: channelId),
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
