import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/widgets/chats/message_bubble.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  void deleteMyMessage(String key){

final removeKey=key.substring(2,key.length-2);
Firestore.instance.collection('chats').document(removeKey).delete();

  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('chats').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else{
          final chatDocs=snapshot.data.documents;
          return FutureBuilder(
            future: FirebaseAuth.instance.currentUser(),
            builder:(ctx, futureSnapshot){

              if(futureSnapshot.connectionState==ConnectionState.waiting){
                return Center(child:CircularProgressIndicator(),);
              }
              

              return ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {

              final checkUser=(chatDocs[index]['userId']==futureSnapshot.data.uid); 

              return MessageBubble(chatDocs[index]['text'], checkUser, ValueKey(chatDocs[index].documentID),chatDocs[index]['userId'],chatDocs[index]['username'],deleteMyMessage);
            },
            itemCount: chatDocs.length,

            );

            } 
          );
        }

      },
      
    );
  }
}