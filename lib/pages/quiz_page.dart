import 'package:flutter/material.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';

import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';

import './score_page.dart';

import 'dart:math';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  
  static createQuestion(bool ans) {
    int a = new Random().nextInt(10);
    int b = new Random().nextInt(10);
    int sum = 0;
    if (ans == true) {
      sum = a * b;
    } else {
      sum = a * b + new Random().nextInt(2) + 1;
    }
    String question = a.toString() + " * " + b.toString() + " = " + sum.toString();
    return question;
  }

  Quiz quiz = new Quiz([
    new Question(createQuestion(false), false),
    new Question(createQuestion(false), false),
    new Question(createQuestion(true), true),
    new Question(createQuestion(false), false),
    new Question(createQuestion(true), true)
  ]);

  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( // This is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true)), //true button
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false)), // false button
          ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(
            isCorrect,
                () {
              if (quiz.length == questionNumber) {
                Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
                return;
              }
              currentQuestion = quiz.nextQuestion;
              this.setState(() {
                overlayShouldBeVisible = false;
                questionText = currentQuestion.question;
                questionNumber = quiz.questionNumber;
              });
            }
        ) : new Container()
      ],
    );
  }
}
