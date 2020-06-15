import 'package:flutter/material.dart';
import './question.dart';
import './answers.dart';

class Quiz extends StatelessWidget {
  final qns;
  final answerQn;
  final qnIndex;

  Quiz({@required this.qns, @required this.answerQn, @required this.qnIndex});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Question(qns[qnIndex]["question"]),
        ...(qns[qnIndex]["answers"] as List<Map<String, Object>>).map((answer) {
          return Answers(()=>answerQn(answer["score"]), answer["ans"]);
        }).toList()
      ],
    );
  }
}
