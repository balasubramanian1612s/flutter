import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  String _enteredMessage;
  final chatController=TextEditingController();

  void _sendMessage()async{
    FocusScope.of(context).unfocus();
    final FirebaseUser user=await FirebaseAuth.instance.currentUser();
    final userData=await Firestore.instance.collection('users').document(user.uid).get();

    chatController.text='';
    await Firestore.instance.collection('chats').add({
      'text':_enteredMessage,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'username':userData['username']
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: chatController,
              onChanged:(value){
              setState(() {
                _enteredMessage=value;
              });
              } ,
              decoration: InputDecoration(labelText:'Send a Message'),
            ),
          ),
          IconButton(icon: Icon(Icons.send), color: Colors.blue, onPressed: () {
            _enteredMessage.trim().isEmpty?null: _sendMessage();
          },)
        ],
      ),
    );
  }
}
