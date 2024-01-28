import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'quiz_result_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  int _timerSeconds = 20;
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<Question> questions = [];

  bool _shouldPauseTimer = false;
  int _originalTimerSeconds = 20;
  late List<bool> _isQuestionAnswered;
  bool _isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _originalTimerSeconds = _timerSeconds;
    _timer = Timer(Duration.zero, () {});
    startTimer();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _timerSeconds),
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    _isQuestionAnswered = List.generate(
      questions.length,
      (index) => false,
    );

    // Fetch questions from Firestore and randomize options
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Conversations').get();

      List<Question> fetchedQuestions = querySnapshot.docs.map((doc) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

        // Fetch other Blackfoot texts to use as options
        List<String> allBlackfootTexts = querySnapshot.docs
            .map((otherDoc) => otherDoc['blackfootText'] as String)
            .toList();

        // Remove the current Blackfoot text from the options
        allBlackfootTexts.remove(docData['blackfootText']);

        // Randomly select a subset of options
        List<String> options = allBlackfootTexts
          ..shuffle(); // Adjust the shuffle logic as needed

        // Take a specific number of options (e.g., 3)
        options = options.take(3).toList();

        // Include the correct answer in the options
        options.add(docData['blackfootText']);

        // Shuffle the options to randomize the order
        options.shuffle();

        return Question(
          docData['englishText'],
          docData['blackfootText'],
          options,
        );
      }).toList();

      // Randomize the order of questions
      fetchedQuestions.shuffle();

      // Take the first 10 (or less) questions
      questions =
          fetchedQuestions.take(min(fetchedQuestions.length, 10)).toList();

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

  void startTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }

    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (_timerSeconds == 0) {
        timer.cancel();
        nextQuestion();
      } else if (!_shouldPauseTimer) {
        setState(() {
          _timerSeconds--;
        });

        _controller.duration = Duration(seconds: _timerSeconds);
      }
    });
  }

  void nextQuestion() {
    setState(() {
      _currentIndex++;
      if (_currentIndex < questions.length) {
        _timerSeconds = _originalTimerSeconds;
        _controller.reset();
        _controller.forward();
        startTimer();
        _isNextButtonEnabled = false;
      } else {
        _isNextButtonEnabled = false;
        // Quiz is completed
        calculateScore();
      }

      updateIsQuestionAnswered();
    });
  }

  void calculateScore() {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].correctAnswer == questions[i].selectedAnswer) {
        correctAnswers++;
      }
    }

    // Navigate to a new screen to display the quiz results
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

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() async {
    _shouldPauseTimer = true;

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
                _timer.cancel();
                _shouldPauseTimer = false;
                Navigator.of(context).pop(true);
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                _shouldPauseTimer = false;
                Navigator.of(context).pop(false);
              },
              child: Text("No"),
            ),
          ],
        ),
      );

      return shouldExit;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          backgroundColor: Color(0xFFcccbff),
        ),
        body: _currentIndex < questions.length
            ? buildQuestionCard(questions[_currentIndex])
            : Container(),
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
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: buildRadioOptionsList(question.options),
            ),
            SizedBox(height: 10.0),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2 * 3.1416,
                  child: Icon(Icons.access_time,
                      size: 60.0, color: Color(0xFFcccbff)),
                );
              },
            ),
            SizedBox(height: 10.0),
            Text(
              "Time left: $_timerSeconds seconds",
              style: TextStyle(fontSize: 24.0, color: Color(0xFFcccbff)),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _isNextButtonEnabled ? nextQuestion : null,
              child: Text("Next"),
              style: ElevatedButton.styleFrom(primary: Color(0xFFcccbff)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRadioOptionsList(List<String> options) {
    return options
        .map(
          (option) => RadioListTile<String>(
            title: Text(
              option,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            value: option,
            groupValue: questions[_currentIndex].selectedAnswer,
            onChanged: (value) {
              setState(() {
                questions[_currentIndex].selectedAnswer = value!;
                _isNextButtonEnabled = true;
              });
            },
            activeColor: Color(0xFFcccbff), // Change radio button color
          ),
        )
        .toList();
  }
}

class Question {
  String questionText;
  String correctAnswer;
  List<String> options;
  String? selectedAnswer;

  Question(this.questionText, this.correctAnswer, this.options);
}
