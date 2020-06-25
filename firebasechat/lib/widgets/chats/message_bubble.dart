import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final printMessage;
  final thisUser;
  final Key key;
  final String username;
  final Function deleteMessage;
  final String userId;
  MessageBubble(this.printMessage, this.thisUser, this.key,this.userId, this.username,
      this.deleteMessage);

  String imageAtLast;
  Future<void> checkData(){
    Firestore.instance.collection('users').snapshots().listen((event) {
      event.documents.forEach((element) {
        //print(element.documentID);
        //print(userId);
        if(element.documentID==userId){
          imageAtLast=element['image'];
          return element['image'];
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressEnd: (details) {
        thisUser
            ? showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('Want To Delete?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          deleteMessage(key.toString());
                          Navigator.of(context).pop();
                        },
                        child: Text('Delete')),
                    FlatButton(
                        onPressed: () {
                          checkData();
                          Navigator.of(context).pop();
                        },
                        child: Text('No')),
                  ],
                ))
            : null;
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Row(
              mainAxisAlignment:
              thisUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 180,
                  decoration: BoxDecoration(
                      color: thisUser ? Colors.blue : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft:
                        thisUser ? Radius.circular(10) : Radius.circular(0),
                        bottomRight:
                        thisUser ? Radius.circular(0) : Radius.circular(10),
                      )),
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 20),
                  padding: EdgeInsets.all(10),
                  child:Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment:thisUser? CrossAxisAlignment.end:CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(

                        username,
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 15),
                      ),

                      Text(
                        printMessage,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  )

                  ,
                ),
              ],
            ),
            StreamBuilder(
              stream: Firestore.instance.collection('users').document(userId).snapshots(),
              builder:(ctx,snapShot){
                if(snapShot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }
                //return Container();
                else if(snapShot.hasData){
                  print(snapShot.data['image']);

                  //print(imageAtLast);
                  return Positioned(
                    right:thisUser? 160:null,
                    left:thisUser? null:160,
                    top: -10,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(snapShot.data['image']),
                    ),
                  );
                }
              },
            ) ,




          ],
        ),
      ),
    );
  }
}
