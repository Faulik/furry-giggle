import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:up4/chat/profile.dart';
import 'package:up4/userBloc.dart';

class ChatInput extends StatefulWidget {
  final CollectionReference thread;

  ChatInput({this.thread});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  final CollectionReference thread;

  _ChatInputState({this.thread});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      hintText: 'Send a message',
                    ),
                    onSubmitted: (_) => handlePressSendMessage(context),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  right: 8.0,
                ),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => handlePressSendMessage(context),
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        profileOverlay(context),
      ],
    );
  }

  Widget profileOverlay(BuildContext context) {
//    if (User().userData != null) {
//      return Container();
//    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Please fill profile to join chat',
              style: TextStyle(color: Theme.of(context).textTheme.button.color),
            ),
            onPressed: () => handlePressProfile(context),
          ),
        ],
      ),
    );
  }

  void handlePressProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Profile(),
      ),
    );
  }

  void handlePressSendMessage(BuildContext context) {
    final String message = _textController.value.text;

    if (true) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Profile()));
      return;
    }

    if (message.length > 0) {
      sendMessage(message);
    }
  }

  Future<void> sendMessage(String value) async {
    if (value.isEmpty) return;

    Message message = Message(message: value);
    await thread.add(message.toMap());

    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class Message {
  String message;
  String senderId;
  String senderName;
  String timestamp;

  Message({this.message, FirebaseUser user}) {
    this.senderId = user.uid;
    this.senderName = user.displayName;
  }

  Map<String, dynamic> toMap() {
    return {
      'message': this.message,
      'senderId': this.senderId,
      'senderName': this.senderName,
      'timestamp': DateTime.now(),
    };
  }
}
