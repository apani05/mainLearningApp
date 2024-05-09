import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Phrases/provider/audioPlayerProvider.dart';
import '../Phrases/provider/blogProvider.dart';
import '../riverpod/river_pod.dart';
import 'quiz_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Question> quizQuestions = [];
  late List<bool> _isQuestionAnswered;
  bool _isNextButtonEnabled = false;
  bool _isSubmitButtonEnabled = false;
  List<String> selectedSeries = [];

  @override
  void initState() {
    super.initState();

    _isQuestionAnswered = [];
    _showSeriesSelectionDialog();
  }

  Future<void> _showSeriesSelectionDialog() async {
    List<String> seriesOptions =
        await ref.read(blogProvider).getSeriesOptions();
    List<bool> isSelected =
        List.generate(seriesOptions.length, (index) => false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Select Series"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: seriesOptions.asMap().entries.map((entry) {
                int index = entry.key;
                String series = entry.value;
                return CheckboxListTile(
                  title: Text(series),
                  value: isSelected[index],
                  onChanged: (value) {
                    setState(() {
                      isSelected[index] = value!;
                    });
                  },
                );
              }).toList(),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              selectedSeries = [];
              for (int i = 0; i < isSelected.length; i++) {
                if (isSelected[i]) {
                  selectedSeries.add(seriesOptions[i]);
                }
              }
              if (selectedSeries.isNotEmpty) {
                fetchQuestionsForSelectedSeries();
                Navigator.pop(context);
              }
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchQuestionsForSelectedSeries() async {
    try {
      List<Question> fetchedQuestions = [];

      for (String series in selectedSeries) {
        List<CardData> cardsForSeries =
            ref.read(blogProvider).filterDataBySeriesName(series);

        for (CardData card in cardsForSeries) {
          if (card.blackfootText.isEmpty) {
            continue;
          }

          List<String> allBlackfootTexts = cardsForSeries
              .where((c) => c.blackfootText != card.blackfootText)
              .map((c) => c.blackfootText)
              .toList();

          allBlackfootTexts =
              allBlackfootTexts.where((text) => text.isNotEmpty).toList();

          allBlackfootTexts.shuffle();

          List<String> options = allBlackfootTexts.take(3).toList();
          options.add(card.blackfootText);
          options.shuffle();

          fetchedQuestions.add(Question(
            questionText: card.englishText,
            correctAnswer: card.blackfootText,
            options: options,
          ));
        }
      }

      fetchedQuestions.shuffle();

      int numberOfQuestionsToKeep = fetchedQuestions.length < 10
          ? fetchedQuestions.length
          : fetchedQuestions.length < 20
              ? 10
              : 20;

      quizQuestions = fetchedQuestions.take(numberOfQuestionsToKeep).toList();

      setState(() {
        _isQuestionAnswered = List.generate(
          quizQuestions.length,
          (index) => false,
        );
      });
    } catch (error) {
      print("Error fetching questions: $error");
    }
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < quizQuestions.length) {
        _isNextButtonEnabled = false;
      } else {
        calculateScore();
      }

      updateIsQuestionAnswered();
    });
  }

  void submitAnswer(Question question) {
    _isNextButtonEnabled = true;
    question.showCorrectAnswer = true;
    setState(() {
      _isSubmitButtonEnabled = false;
    });
  }

  void calculateScore() {
    int quizScore = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (quizQuestions[i].correctAnswer == quizQuestions[i].selectedAnswer) {
        quizScore++;
      }
    }
    ref.read(blogProvider).saveQuizResults(quizScore, quizQuestions);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          quizScore: quizScore,
          quizQuestions: quizQuestions,
        ),
      ),
    );
  }

  void updateIsQuestionAnswered() {
    setState(() {
      _isQuestionAnswered = List.generate(
        quizQuestions.length,
        (index) => false,
      );
    });
  }

  Future<bool> _onBackPressed() async {
    if (_currentIndex < quizQuestions.length) {
      bool shouldExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text("Exit Quiz?"),
          content: Text("Are you sure you want to exit the quiz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
        ),
      );

      return shouldExit ?? false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (mounted) {
                  _onBackPressed().then((shouldPop) {
                    if (shouldPop) {
                      Navigator.pop(context);
                    }
                  });
                }
              },
            ),
            title: Text('Quiz'),
            backgroundColor: theme.lightPurple,
          ),
          body: SingleChildScrollView(
            child: _currentIndex < quizQuestions.length
                ? buildQuestionCard(quizQuestions[_currentIndex])
                : Container(),
          ),
          bottomNavigationBar: BottomAppBar(
            color: theme.lightPurple,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${quizQuestions.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isNextButtonEnabled ? nextQuestion : null,
                    child: Text("Next"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionCard(Question question) {
    final player = ref.watch(audioPlayerProvider);
    final theme = ref.watch(themeProvider);
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: theme.lightPurple,
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildRadioOptionsList(question.options),
            ),
            if (question.showCorrectAnswer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Correct Answer: ${question.correctAnswer}",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed:
                  _isSubmitButtonEnabled ? () => submitAnswer(question) : null,
              child: Text("Submit"),
              style:
                  ElevatedButton.styleFrom(backgroundColor: theme.lightPurple),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRadioOptionsList(List<String> options) {
    final theme = ref.watch(themeProvider);
    return options.map((option) {
      return RadioListTile<String>(
        title: Text(
          option,
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        ),
        value: option,
        groupValue: quizQuestions[_currentIndex].selectedAnswer,
        onChanged: (value) {
          setState(() {
            if (!quizQuestions[_currentIndex].showCorrectAnswer) {
              quizQuestions[_currentIndex].selectedAnswer = value!;
              _isSubmitButtonEnabled = true;
            }
          });
        },
        activeColor: theme.lightPurple,
      );
    }).toList();
  }
}
