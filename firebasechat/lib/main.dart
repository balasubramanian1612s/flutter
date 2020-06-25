import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/screens/auth_screen.dart';
import 'package:firebasechat/screens/chat_screen.dart';
import 'package:firebasechat/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Char',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.purple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
      ),
      home: StreamBuilder(stream:FirebaseAuth.instance.onAuthStateChanged, builder:(ctx, userSnapshot){
        if(userSnapshot.connectionState==ConnectionState.waiting){
          return SplashScreen();
        }
        else if(userSnapshot.hasData){
          print(FirebaseAuth.instance.currentUser());
          return ChatScreen();
        }else{

          return AuthScreen();

        }
      } ,) ,
    );
  }
}