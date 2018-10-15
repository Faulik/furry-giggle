import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final String sender;
  final DateTime date;

  const ChatMessage({Key key, this.message, this.sender, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 48,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender.isEmpty ? 'Unknown' : sender,
            style: TextStyle(
              fontSize: 10.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(message),
        ],
      ),
    );
  }
}
