import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../Phrases/provider/blogProvider.dart';
import '../riverpod/river_pod.dart';
import 'quiz_result_page.dart';

class QuizResultList extends ConsumerStatefulWidget {
  const QuizResultList({super.key});

  @override
  _QuizResultListState createState() => _QuizResultListState();
}

class _QuizResultListState extends ConsumerState<QuizResultList> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.read(themeProvider);
    final blogProviderObj = ref.read(blogProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
        backgroundColor: theme.lightPurple,
      ),
      body: FutureBuilder<List<Quiz>>(
        future: blogProviderObj.getUserQuizResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final quizResults = snapshot.data!;

            return ListView.builder(
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                final quizResult = quizResults[index];
                final quizIndex = index + 1;
                final quizScore = quizResult.quizScore;
                final totalPoints = quizResult.totalPoints;

                final dateSubmitted = (quizResult.dateSubmitted).toDate();

                final formattedDate =
                    DateFormat('MM/dd/yy').format(dateSubmitted);

                return ListTile(
                  title: Text('Quiz $quizIndex'),
                  subtitle: Text('$quizScore / $totalPoints'),
                  trailing: Text(formattedDate),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizResultScreen(
                          quizScore: quizScore,
                          quizQuestions: quizResult.questionSet,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
