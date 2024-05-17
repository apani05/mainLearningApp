import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../Phrases/provider/blogProvider.dart';
import '../riverpod/river_pod.dart';
import 'quiz_result_page.dart';
import 'widgets/bar_graph.dart';

class QuizResultList extends ConsumerStatefulWidget {
  const QuizResultList({super.key});

  @override
  _QuizResultListState createState() => _QuizResultListState();
}

class _QuizResultListState extends ConsumerState<QuizResultList> {
  List<Quiz> quizResults = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final blogProviderObj = ref.read(blogProvider);
    quizResults = await blogProviderObj.getUserQuizResults();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(themeProvider);
    // Calculate daily, weekly, and monthly average quiz scores
    final dailyAverage = QuizBarData.calculateDailyAverage(quizResults);
    final weeklyAverage = QuizBarData.calculateWeeklyAverage(quizResults);
    final monthlyAverage = QuizBarData.calculateMonthlyAverage(quizResults);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Scores'),
        backgroundColor: theme.lightPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: QuizBarData.buildBarGraph(
                weeklyAverage, dailyAverage, monthlyAverage),
          ),
          Expanded(
            child: ListView.builder(
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
            ),
          ),
        ],
      ),
    );
  }
}
