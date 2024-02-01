import 'dart:async';
import 'package:flutter/material.dart';
import 'quiz_page.dart';

class QuizResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final List<Question> questions;

  const QuizResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.questions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
        backgroundColor: Color(0xFFcccbff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 20.0),
            Icon(
              Icons.done_all,
              size: 60.0,
              color: Color(0xFFcccbff),
            ),
            SizedBox(height: 20.0),
            Text(
              'You answered $correctAnswers out of $totalQuestions questions correctly.',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Correct Answers:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            ...questions
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Q${entry.key + 1}: ${entry.value.correctAnswer}',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color(0xFFcccbff),
                      ),
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
