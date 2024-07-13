import 'package:bfootlearn/Phrases/models/quiz_model.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../riverpod/river_pod.dart';
import '../widgets/bar_graph.dart';
import 'quiz_result_page.dart';

class QuizResultList extends ConsumerStatefulWidget {
  const QuizResultList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QuizResultListState();
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
    quizResults = await blogProviderObj.fetchQuizResultsFromFirebase();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.read(themeProvider);
    final eachSeriesScore = QuizBarData.calculateSeriesTypeScore(quizResults);

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Quiz Performance'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          quizResults.isEmpty
              ? const Center(
                  child: Text(
                    'No quizzes taken yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: QuizBarData.buildBarGraph(eachSeriesScore),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: quizResults.length,
                        itemBuilder: (context, index) {
                          final quizResult = quizResults[index];
                          final quizIndex = index + 1;
                          final quizScore = quizResult.quizScore;
                          final totalPoints = quizResult.totalPoints;
                          final dateSubmitted =
                              quizResult.dateSubmitted.toDate();
                          final formattedDate = DateFormat('MM/dd/yy HH:mm')
                              .format(dateSubmitted);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.lightPurple.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme.lightPurple,
                                  width: 1,
                                ),
                              ),
                              child: ListTile(
                                title: Text('Quiz $quizIndex'),
                                subtitle:
                                    Text('Score: $quizScore / $totalPoints'),
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
