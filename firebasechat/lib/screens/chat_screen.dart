import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasechat/widgets/chats/messages.dart';
import 'package:firebasechat/widgets/chats/new_messages.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm=FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg){
        print(msg);
        return;
      },
      onLaunch: (message) {
        print(message);
      },
      onResume: (message) {
        print(message);
      },
    );
    fbm.subscribeToTopic('chat');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🔥FireBase Chat🔥'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          DropdownButton(icon: Icon(Icons.more_vert, color: Colors.white,),
          underline: Container(),
          items:[
            DropdownMenuItem(child: Container(


              child: Row(
                children: <Widget>[
                  Icon(Icons.exit_to_app),
                  SizedBox(width: 8,),
                  Text('Logout'),
                ],
              ),

            ),
            value: 'logout',
            )
          ], onChanged: (itemIdentifier){
if(itemIdentifier=='logout'){
  FirebaseAuth.instance.signOut();
}
          })
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: Messages(),),
            NewMessages()
          ],
        ),
      )
    );
  }
}
