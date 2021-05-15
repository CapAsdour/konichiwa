import 'package:flutter/material.dart';
import 'package:flutter_app/model/user.dart';

class Conversation extends StatefulWidget {
  User user;
  Conversation({@required this.user});
  static const ROUTE_CONVERSATION = '/route-conversation';
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Wrap(
            children: [
              Expanded(
                child: widget.user.imageUrl == ''
                    ? Icon(Icons.person)
                    : CircleAvatar(
                        backgroundImage: NetworkImage(widget.user.imageUrl),
                        radius: 10,
                      ),
              ),
              Expanded(child: Text(widget.user.UserName)),
            ],
          ),
        ),
      
      body: Container(),
    );
  }
}
