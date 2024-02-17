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
    final screenWidth = MediaQuery.of(context).size.width;

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
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: theme.lightPurple,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                Icon(
                  Icons.done_all,
                  size: screenWidth * 0.15,
                  color: theme.lightPurple,
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  'You answered ${widget.correctAnswers} out of ${widget.totalQuestions} questions correctly.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: theme.lightPurple,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  'Correct Answers:',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: theme.lightPurple,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                ...widget.questions
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Q${entry.key + 1}: ${entry.value.questionText}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: theme.lightPurple,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.02),
                            if (entry.value.selectedAnswer !=
                                entry.value.correctAnswer)
                              Text(
                                'Your Answer: ${entry.value.selectedAnswer}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: theme.red,
                                ),
                              ),
                            Text(
                              'Correct Answer: ${entry.value.correctAnswer}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: theme.green,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.04),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
