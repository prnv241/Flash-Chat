import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {

  static String scrId = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String msgtext;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if(user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch(e) {
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
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
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
                        msgtext = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({'text': msgtext, 'sender': loggedInUser.email, 'createdAt': FieldValue.serverTimestamp()});
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
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').orderBy('createdAt', descending: false).snapshots(),
        builder: (context, snapshot) {
          List<MessageBubble> messageWidgets = [];
          if(snapshot.hasData) {
            final messages = snapshot.data.docs.reversed;
            for(var message in messages) {
              final messageText = message.data()['text'];
              final messageSender = message.data()['sender'];
              final currentUser = loggedInUser.email;
              final messageWidget = MessageBubble(sender: messageSender, text: messageText, isme: currentUser == messageSender,);
              messageWidgets.add(messageWidget);
            }
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        }
    );
  }
}


class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isme;
  MessageBubble({this.sender, this.text, this.isme});
  @override
  Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(isme ? 30 : 0), topRight: Radius.circular(isme ? 0 : 30), bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              color: isme ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20,),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isme ? Colors.white : Colors.black54,
                    fontSize: 15,
                  ),
                ),
              ),
    ),
          ],
        ),
      );
  }
}