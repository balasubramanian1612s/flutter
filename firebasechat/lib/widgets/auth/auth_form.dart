import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasechat/screens/chat_screen.dart';
import 'package:firebasechat/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitData);
  final void Function(
      String email, String password, String username, File image, bool isLogin, ScaffoldState context) submitData;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _login() async{
    try{
      GoogleSignInAccount account=await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth= await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final AuthResult authResult = await _auth.signInWithCredential(credential);
      FirebaseUser user = authResult.user;
      print(FirebaseAuth.instance.currentUser());
      setState(() {
        _isLoggedIn = true;
      });
      await Firestore.instance
          .collection("users")
          .document(_googleSignIn.currentUser.id)
          .setData({"username": _googleSignIn.currentUser.displayName, "email": _googleSignIn.currentUser.email, 'image':_googleSignIn.currentUser.photoUrl});
     // Navigator.of(context).pushNamed()

    } catch (err){
      print(err);
    }
  }

  _logout(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }



  var newSignUp = true;
  String username;
  String email;
  String password;
  File image;

  void selectedImage(File img){
    image=img;
  }

  final _authForm = GlobalKey<FormState>();
  void switchSignMode() {
    setState(() {
      newSignUp = !newSignUp;
    });
  }

  void submitForm() {
    if(newSignUp && image==null){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please Choose An Image!')));
      return;
    }
    if (_authForm.currentState.validate()) {
      _authForm.currentState.save();
      widget.submitData(email, password, username,image, newSignUp ? false : true, Scaffold.of(context));

      print(username);
      print(email);
      print(password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Center(
        child: Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _authForm,
            child: Column(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    newSignUp? UserImagePicker(selectedImage):Container(height: 0,width: 0,),

                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      onSaved: (newValue) {
                        email = newValue;
                      },
                      validator: (value) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return "Email Type Not Valid";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email Address'),
                    ),
                    newSignUp
                        ? TextFormField(
                      autocorrect: false,
                            textCapitalization: TextCapitalization.words,
                            enableSuggestions: false,
                            onSaved: (newValue) {
                              username = newValue;
                            },
                            validator: (value) {
                              if (value.length <= 5) {
                                return 'Minimum of 5 Characters Please';
                              }
                              return null;
                            },
                            decoration: InputDecoration(labelText: 'Username'),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                    TextFormField(
                      onSaved: (newValue) {
                        password = newValue;
                      },
                      validator: (value) {
                        if (value.length < 6) {
                          return 'Password Must Be Minimum of 6 Characters';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                        onPressed: () {
                          submitForm();
                        },
                        child: Text(newSignUp ? 'Sign Up' : 'Login')),
                    FlatButton(
                        onPressed: () {
                          switchSignMode();
                        },
                        child: Text(
                            newSignUp ? 'Login Instead' : 'Create New Account'))
                  ],
                ),

                Row(
                  children: <Widget>[
                    FlatButton(

                      child:  _isLoggedIn
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.network(_googleSignIn.currentUser.photoUrl, height: 50.0, width: 50.0,),
                          Text(_googleSignIn.currentUser.displayName),
                          OutlineButton( child: Text("Logout"), onPressed: (){
                            _logout();
                          },)
                        ],
                      )
                          : Center(
                        child: OutlineButton(
                          child: Text("Login with Google"),
                          onPressed: () {
                            _login();
                          },
                        ),
                      )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
