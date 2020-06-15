import 'package:flutter/material.dart';

class Answers extends StatelessWidget {
  final Function stateHandler;
  final String answerText;
  Answers(this.stateHandler, this.answerText);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text(answerText),
          onPressed: stateHandler,
        ));
  }
}
