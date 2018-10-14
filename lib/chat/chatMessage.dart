import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final String sender;
  final DateTime date;

  const ChatMessage({Key key, this.message, this.sender, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 8.0),
            child: Text(
              sender.isEmpty ? '???' : sender,
            ),
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 48,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            padding: EdgeInsets.all(8.0),
            child: Text(
              message
            ),
          ),
        ],
      ),
    );
  }
}
