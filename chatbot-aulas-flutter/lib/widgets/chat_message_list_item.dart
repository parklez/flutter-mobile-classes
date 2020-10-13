import 'package:chatbot/models/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessageListItem extends StatelessWidget {
  final ChatMessage chatMessage;

  ChatMessageListItem({this.chatMessage});

  @override
  Widget build(BuildContext context) {
    return chatMessage.type == ChatMessageType.sent
        ? _showSentMessage()
        : _showReceivedMessage();
  }

    Widget _showSentMessage({EdgeInsets padding, TextAlign textAlign}) {
    var now = new DateTime.now();

    return Container(
      child: ListTile(
      contentPadding: EdgeInsets.fromLTRB(64.0, 0.0, 8.0, 0.0),
      trailing: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text(chatMessage.name, textAlign: TextAlign.right, style: TextStyle(color: Colors.black.withOpacity(0.5))),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.right, style: TextStyle(color: Colors.black)),
      dense: true,
      leading: Text('⌚${DateFormat("H:m:s").format(now)}', textAlign: TextAlign.left),
    ),
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(30.0),
        right: Radius.circular(30.0)
    )
    ),
    );
  }

    Widget _showReceivedMessage() {
    var now = new DateTime.now();

    return Container(child: ListTile(
      contentPadding: EdgeInsets.fromLTRB(8.0, 0.0, 64.0, 0.0),
      leading: CircleAvatar(child: Text(chatMessage.name.toUpperCase()[0])),
      title: Text(chatMessage.name, textAlign: TextAlign.left, style: TextStyle(color: Colors.black.withOpacity(0.5))),
      subtitle: Text(chatMessage.text, textAlign: TextAlign.left, style: TextStyle(color: Colors.black)),
      dense: true,
      trailing: Text('${DateFormat("H:m:s").format(now)}⌚', textAlign: TextAlign.right),
    ),
    decoration: BoxDecoration(
      color: Colors.pink[100],
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(30.0),
        right: Radius.circular(30.0)
    )
    ),
    
    );
    
  }
}
