import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  List<Question> questions = [];
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
    List<String> seriesOptions = await _getSeriesNamesFromFirestore();

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
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Conversations')
            .where('seriesName', isEqualTo: series)
            .get();

        List<Question> seriesQuestions = querySnapshot.docs.map((doc) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

          List<String> allBlackfootTexts = querySnapshot.docs
              .map((otherDoc) => otherDoc['blackfootText'] as String)
              .toList();

          allBlackfootTexts.remove(docData['blackfootText']);

          List<String> options = allBlackfootTexts..shuffle();

          options = options.take(3).toList();

          options.add(docData['blackfootText']);

          options.shuffle();

          return Question(
            docData['englishText'],
            docData['blackfootText'],
            options,
          );
        }).toList();

        fetchedQuestions.addAll(seriesQuestions);
      }

      fetchedQuestions.shuffle();

      int numberOfQuestionsToKeep = fetchedQuestions.length < 10
          ? fetchedQuestions.length
          : fetchedQuestions.length < 20
              ? 10
              : 20;

      questions = fetchedQuestions.take(numberOfQuestionsToKeep).toList();

      setState(() {
        _isQuestionAnswered = List.generate(
          questions.length,
          (index) => false,
        );
      });
    } catch (error) {
      print("Error fetching questions: $error");
    }
  }

  Future<List<String>> _getSeriesNamesFromFirestore() async {
    List<String> seriesNames = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ConversationTypes')
          .get();

      seriesNames = querySnapshot.docs.map((doc) {
        String seriesName = doc['seriesName'];
        return seriesName;
      }).toList();
    } catch (error) {
      print("Error fetching series names: $error");
    }

    return seriesNames;
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < questions.length) {
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
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == questions[i].selectedAnswer) {
        correctAnswers++;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultScreen(
          correctAnswers: correctAnswers,
          totalQuestions: questions.length,
          questions: questions,
        ),
      ),
    );
  }

  void updateIsQuestionAnswered() {
    setState(() {
      _isQuestionAnswered = List.generate(
        questions.length,
        (index) => false,
      );
    });
  }

  Future<bool> _onBackPressed() async {
    if (_currentIndex < questions.length) {
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
          body: _currentIndex < questions.length
              ? buildQuestionCard(questions[_currentIndex])
              : Container(),
          bottomNavigationBar: BottomAppBar(
            color: theme.lightPurple,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${questions.length}',
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
        groupValue: questions[_currentIndex].selectedAnswer,
        onChanged: (value) {
          setState(() {
            if (!questions[_currentIndex].showCorrectAnswer) {
              questions[_currentIndex].selectedAnswer = value!;
              _isSubmitButtonEnabled = true;
            }
          });
        },
        activeColor: theme.lightPurple,
      );
    }).toList();
  }
}

class Question {
  String questionText;
  String correctAnswer;
  List<String> options;
  String? selectedAnswer;
  bool showCorrectAnswer;

  Question(this.questionText, this.correctAnswer, this.options)
      : showCorrectAnswer = false;
}
