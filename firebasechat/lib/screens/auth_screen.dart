import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasechat/widgets/auth/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  void _submintAuthForm(String email, String password, String username,File image, bool isLogin, ScaffoldState ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        isLoading = true;
      });

      
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final imageRef=FirebaseStorage.instance.ref().child('Profile_Images').child(authResult.user.uid+'.png');
        await imageRef.putFile(image).onComplete;
        final upImage=await imageRef.getDownloadURL();
        await Firestore.instance
          .collection("users")
          .document(authResult.user.uid)
          .setData({"username": username, "email": email, 'image':upImage});
      }
    } on PlatformException catch (err) {
      var message = "An error Occured! Check Credentials";
      setState(() {
        isLoading = false;
      });
      if (err.message != null) {
        ctx.showSnackBar(SnackBar(
          content: Text(message),
        ));

      }
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      ctx.showSnackBar(SnackBar(
        content: Text('SomeThing Went Wrong!'),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : AuthForm(_submintAuthForm));
  }
}
