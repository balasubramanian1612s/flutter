import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyApyb88fez-L6qExc93sq5EpZ22AjMvC0c';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final userData=json.encode(
        {
          'token':_token,
          'userId':_userId,
          'expiryDate':_expiryDate.toIso8601String()
        }
      );
      prefs.setString("userData", userData);

    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<bool> tryAutoLogin()async{

    final prefs=await SharedPreferences.getInstance();
    print(prefs.containsKey("userData"));
    if(!prefs.containsKey("userData")){
      print("NotFound");
      return false;
    }
    else{
      final extractedUserDataModel=prefs.getString("userData");
      final extractedUserData=json.decode(extractedUserDataModel);
      print(extractedUserData);
      print(extractedUserData['userId']);
      print(extractedUserData['expiryDate']);
      print(extractedUserData['token']);

      if(extractedUserData['expiryDate']==null){
        print("ExpiryDate");
      }
      final expiryDate=DateTime.parse(extractedUserData['expiryDate']);

      if(!expiryDate.isAfter(DateTime.now())){
        print("ExpiryDateFalse");
        return false;
      }
      _userId=extractedUserData['userId'];
      _token=extractedUserData['token'];
      _expiryDate=DateTime.parse(extractedUserData['expiryDate']);
      print("ExpiryDateTrue");
      notifyListeners();
      _autoLogout();
      return true;

    }

  }

  Future<void> logout() async{
    _token=null;
    _userId=null;
    _expiryDate=null;
    if(_authTimer!=null){
      _authTimer.cancel();
    }
    
    notifyListeners();
    final pref=await SharedPreferences.getInstance();
    // pref.remove('userData');
    pref.clear();
  }

  void _autoLogout(){
    if(_authTimer!=null){
      _authTimer.cancel();
    }
final timeToExpire=_expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds:timeToExpire ), logout);

  }
}
