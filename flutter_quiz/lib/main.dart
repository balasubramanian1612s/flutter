import 'package:flutter/material.dart';
import './question.dart';
import './answers.dart';
import './result.dart';
import './quiz.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var qnIndex = 0;
  var _totalScore=0;

  void resetQuiz(){
    setState(() {
      _totalScore=0;
    qnIndex=0;
    });
    
  }

  void answerQn(int score) {
    _totalScore=_totalScore+score;
    print(_totalScore);
    setState(() {
      qnIndex = qnIndex + 1;
    });
    print('Ansert Chosen');

    print(qnIndex);
  }

  @override
  Widget build(BuildContext context) {
    var qns = [
      {
        "question": "Name",
        "answers": [{"ans":"Bala","score":10}, {"ans":"Roshan","score":5}, {"ans":"Pravenn","score":1}]
      },
      {
        "question": "Love Place",
        "answers": [{"ans":"Robust","score":10}, {"ans":"Garden","score":5}, {"ans":"Mountain","score":1}]
      },
      {
        "question": "Animal",
        "answers": [{"ans":"Dog","score":10}, {"ans":"Cat","score":5}, {"ans":"Others","score":1}]
      }
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: qnIndex < qns.length
            ? Quiz(qns: qns, qnIndex: qnIndex, answerQn: answerQn)
            : Result(_totalScore,resetQuiz),
      ),
    );
  }
}
