import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:up4/chat/profile.dart';
import 'package:up4/services/userBloc.dart';

class ChatInput extends StatefulWidget {
  final CollectionReference thread;

  ChatInput({this.thread});

  @override
  _ChatInputState createState() => _ChatInputState(thread: this.thread);
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _textController = TextEditingController();
  final CollectionReference thread;

  _ChatInputState({
    @required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    final user = UserWidget.of(context);

    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: Colors.grey, width: 1.0),
            ),
          ),
          child: StreamBuilder(stream: user.userSubject, builder: inputBlock),
        ),
        StreamBuilder(
          stream: user.userSubject,
          builder: profileOverlay,
        )
      ],
    );
  }

  Widget inputBlock(BuildContext context, AsyncSnapshot<User> snapshot) {
    final Widget textInput = Expanded(
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
          onSubmitted: (_) => handlePressSendMessage(context, snapshot),
        ),
      ),
    );

    final Widget sendButton = Container(
      margin: EdgeInsets.only(
        right: 8.0,
      ),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        onPressed: snapshot.hasData
            ? () => handlePressSendMessage(context, snapshot)
            : null,
        child: Text(
          'Send',
          style: TextStyle(
            color: Theme.of(context).textTheme.button.color,
          ),
        ),
      ),
    );

    return Row(
      children: <Widget>[
        textInput,
        sendButton,
      ],
    );
  }

  Widget profileOverlay(BuildContext context, AsyncSnapshot<User> snapshot) {
    if (snapshot.hasData) {
      return Container();
    }

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

  Future<void> handlePressSendMessage(
      BuildContext context, AsyncSnapshot<User> user) async {
    final String message = _textController.value.text;

    if (message.length == 0 || message.isEmpty || !user.hasData) return;

    _textController.clear();

    Message newMessage = Message(message: message, user: user.data);
    await thread.add(newMessage.toMap());
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

  Message({this.message, User user}) {
    this.senderId = user.auth.uid;
    this.senderName = user.profile.name;
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
