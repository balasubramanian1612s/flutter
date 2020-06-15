import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String qnText;
  Question(this.qnText);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child:Text(
      qnText,
      style: TextStyle(fontSize: 28),
      textAlign: TextAlign.center,
    ));
  }
}
