import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:up4/chat/chatMessage.dart';

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

class Chat extends StatefulWidget {
  final String channelId;

  const Chat({this.channelId});

  @override
  _ChatState createState() => _ChatState(
        channelId: this.channelId,
      );
}

class _ChatState extends State<Chat> {
  final String channelId;
  final TextEditingController _textController = TextEditingController();

  CollectionReference thread;

  _ChatState({this.channelId}) {
    thread = Firestore.instance
        .collection('channels')
        .document(channelId)
        .collection('thread');
    print(thread);
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
            child: buildMessageList(),
          ),
          Container(
            decoration: BoxDecoration(
              border: BorderDirectional(
                top: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
            child: buildSendInput(),
          ),
        ],
      ),
    );
  }

  Widget buildSendInput() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
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
              onSubmitted: (_) => handlePressSendMessage(),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            right: 8.0,
          ),
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            onPressed: handlePressSendMessage,
            child: Text(
              'Send',
              style: TextStyle(
                color: Theme.of(context).textTheme.button.color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMessageList() {
    if (thread == null) return Text('Loading...');

    return StreamBuilder(
      stream:
          thread.orderBy('timestamp', descending: true).limit(50).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return Text('Loading...');

        List<DocumentSnapshot> messages = snapshot.data.documents;

        return ListView.builder(
          padding: EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) {
            return ChatMessage(
              key: Key(messages[index].documentID),
              message: messages[index]['message'],
              sender: messages[index]['senderName'],
              date: messages[index]['timestamp'],
            );
          },
          itemCount: messages.length,
        );
      },
    );
  }

  void handlePressSendMessage() {
    final String message = _textController.value.text;

    if (message.length > 0) {
      sendMessage(message);
    }
  }

  Future<void> sendMessage(String value) async {
    if (value.isEmpty) return;

    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Message message = Message(message: value, user: user);
    await thread.add(message.toMap());

    _textController.clear();
  }
}
