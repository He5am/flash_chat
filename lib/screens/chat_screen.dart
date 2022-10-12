// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api, use_key_in_widget_constructors, deprecated_member_use, sort_child_properties_last

import 'package:flutter/material.dart';
import '/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

final _firebase = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firebase = FirebaseFirestore.instance;

  String? messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getMessages() async {
    final messages = await _firebase.collection("messages").get();
    for (var message in messages.docs) {
      print(message.data());
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firebase.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app_outlined),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                messagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ProgressHUD(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextController,
                        onChanged: (value) {
                          messageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        messageTextController.clear();
                        _firebase.collection("messages").add({
                          'Text': messageText,
                          'Sender': loggedInUser?.email,
                        });
                        //Implement send functionality.

                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebase.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: Text('Say Hi'));
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> MessageBubbles = [];
        for (var message in messages) {
          final messageText = message['Text'];
          final messageSender = message['Sender'];
          final currentUser = loggedInUser?.email;
          if (currentUser == messageSender) {}
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          MessageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: MessageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, required this.sender, required this.text, required this.isMe})
      : super(key: key);

  final String? sender;
  final String? text;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
        isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              sender!,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Material(
            borderRadius: isMe! ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ) : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            elevation: 5,
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Text(
                '$text ',
                style: TextStyle(fontSize: 15, color: isMe! ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
