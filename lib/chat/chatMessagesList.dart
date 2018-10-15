import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:up4/chat/chatMessage.dart';

class ChatMessagesList extends StatefulWidget {
  final String channelId;

  ChatMessagesList({this.channelId});

  @override
  _ChatMessagesListState createState() =>
      _ChatMessagesListState(channelId: channelId);
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  final String channelId;
  final _animateListKey = new GlobalKey<AnimatedListState>();
  CollectionReference thread;
  List<DocumentSnapshot> _messages = [];
  StreamSubscription<QuerySnapshot> _streamSubscription;

  _ChatMessagesListState({this.channelId}) {
    thread = Firestore.instance
        .collection('channels')
        .document(channelId)
        .collection('thread');
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  _init() async {
    await loadMessages();
    await subscribeToMessages();
  }

  Future<void> subscribeToMessages() async {
    _streamSubscription = thread
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(handleNewMessage);
  }

  void handleNewMessage(QuerySnapshot snapshot) {
    final List<DocumentChange> newDocuments = snapshot.documentChanges
        .where(
          // TODO: optimize this
          (element) => _messages.every(
              (message) => message.documentID != element.document.documentID),
        )
        .toList();

    if (newDocuments.isNotEmpty) {
      setState(() {
        _messages.addAll(
          newDocuments.map((DocumentChange change) => change.document),
        );
        for (int i = 0; i < newDocuments.length; i++) {
          _animateListKey.currentState?.insertItem(0);
        }
      });
    }
  }

  Future<void> loadMessages() async {
    final documents = await thread
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();

    setState(() {
      _messages.addAll(documents.documents);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (thread == null || _messages.length == 0) return Text('Loading...');

    return AnimatedList(
      key: _animateListKey,
      padding: EdgeInsets.all(8.0),
      reverse: true,
      initialItemCount: _messages.length,
      itemBuilder: (_, int index, Animation<double> animation) {
        final message = _messages[index];

        return SizeTransition(
          axis: Axis.vertical,
          sizeFactor: animation,
          child: ChatMessage(
            key: Key(message.documentID),
            message: message['message'],
            sender: message['senderName'],
            date: message['timestamp'],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}