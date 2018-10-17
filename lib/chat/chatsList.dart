import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:up4/chat/chat.dart';
import 'package:up4/userBloc.dart';

class ChatsList extends StatefulWidget {
  @override
  _ChatsListState createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text('Chats'),
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance.collection('channels').snapshots(),
            builder: buildList,
          )
        ],
      ),
    );
  }

  Widget buildList(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    if (!snapshot.hasData) return Text('Loading...');

    return Expanded(
      child: ListView(
        children: snapshot.data.documents.map((DocumentSnapshot document) {
          return ListTile(
            title: Text(document['title']),
            subtitle: Text('messages: ${document['count']}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return Chat(
                      channelId: document.documentID.toString(),
                    );
                  },
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
