import 'dart:async';

import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _timerSeconds = 20;
  int _currentIndex = 0;

  List<Question> questions = [
    Question("What's your name?", "Tsá kitáánikko?",
        ["Option 1", "Tsá kitáánikko?", "Option 3", "Option 4"]),
    // Add other questions here
  ];

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    Timer.periodic(oneSecond, (timer) {
      if (_timerSeconds == 0) {
        // Time is up, handle accordingly (e.g., mark the question as incorrect)
        timer.cancel();
        nextQuestion();
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  void nextQuestion() {
    // Handle what to do when the timer reaches 0
    // For now, let's just move to the next question
    setState(() {
      _currentIndex++;
      if (_currentIndex < questions.length) {
        _timerSeconds = 20;
        startTimer();
      } else {
        // All questions are done
        // You may want to navigate to the results screen or perform any other action
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Section'),
      ),
      body: _currentIndex < questions.length
          ? buildQuestionCard(questions[_currentIndex])
          : Center(
              child: Text('Quiz Completed!'),
            ),
    );
  }

  Widget buildQuestionCard(Question question) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            DragTarget<String>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  color: Colors.grey[200],
                  child: Text("Drag and drop your answer here"),
                );
              },
              onWillAccept: (data) => data == question.correctAnswer,
              onAccept: (data) {
                // Handle the correct answer here
                // You may want to update the score or perform any other action
                print("Selected Answer: $data");
                nextQuestion();
              },
            ),
            SizedBox(height: 10.0),
            buildOptionsList(question.options),
            SizedBox(height: 10.0),
            Text("Time left: $_timerSeconds seconds"),
          ],
        ),
      ),
    );
  }

  Widget buildOptionsList(List<String> options) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: options
          .map((option) => Draggable<String>(
                data: option,
                child: buildOptionCard(option),
                feedback: buildOptionCard(option, isDragging: true),
                childWhenDragging: Container(),
              ))
          .toList(),
    );
  }

  Widget buildOptionCard(String option, {bool isDragging = false}) {
    return Card(
      color: isDragging ? Colors.transparent : Colors.purple,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          option,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class Question {
  String questionText;
  String correctAnswer;
  List<String> options;

  Question(this.questionText, this.correctAnswer, this.options);
}
