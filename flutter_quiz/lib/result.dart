import 'package:flutter/material.dart';
import './question.dart';
import './answers.dart';

class Result extends StatelessWidget {
  final int totalScore;
  final Function resetQuiz;
  Result(this.totalScore, this.resetQuiz);
  String get textForResult {
    if (totalScore < 8) {
      return "Awesome You re";
    } else if (totalScore < 12) {
      return "Ridiculous You re";
    }
    if (totalScore < 20) {
      return "Bitch You re";
    } else {
      return 'Please Go Away';
    }
  }

  @override
  Widget build(BuildContext context) {
    return (Center(
        child: Column(
          children: <Widget>[
            Text(
      textForResult,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    ),
    FlatButton(onPressed: resetQuiz, child: Text("Restart Quiz"), textColor: Colors.blue,)
          ],
        )));
  }
}
