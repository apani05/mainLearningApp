import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/river_pod.dart';
import 'quiz_page.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
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
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (mounted) {
                Navigator.pop(context);
              }
            },
          ),
          title: Text('Quiz Result'),
          backgroundColor: theme.lightPurple,
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
                  color: theme.lightPurple,
                ),
              ),
              SizedBox(height: 20.0),
              Icon(
                Icons.done_all,
                size: 60.0,
                color: theme.lightPurple,
              ),
              SizedBox(height: 20.0),
              Text(
                'You answered ${widget.correctAnswers} out of ${widget.totalQuestions} questions correctly.',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: theme.lightPurple,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                'Correct Answers:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: theme.lightPurple,
                ),
              ),
              SizedBox(height: 10.0),
              ...widget.questions
                  .asMap()
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Q${entry.key + 1}: ${entry.value.correctAnswer}',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: theme.lightPurple,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
