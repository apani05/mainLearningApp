import 'dart:async';
import 'package:flutter/material.dart';

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

  List<Question> questions = [
    Question(
        "How are you?", "Okihkiita?", ["Good", "Okihkiita?", "Bad", "So-so"]),
    Question("What is your name?", "Tsá kitáánikko?",
        ["Option 1", "Tsá kitáánikko?", "Option 3", "Option 4"]),
    Question("Hello, nice to meet you.", "Tsí̠kʷayímohkiyaki?",
        ["Option 1", "Tsí̠kʷayímohkiyaki?", "Option 3", "Option 4"]),
    Question("What are you doing these days?", "Okihkiita moxkíitapi?",
        ["Option 1", "Okihkiita moxkíitapi?", "Option 3", "Option 4"]),
  ];

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
  }

  void updateIsQuestionAnswered() {
    setState(() {
      _isQuestionAnswered = List.generate(
        questions.length,
        (index) => false,
      );
    });
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
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                      'Correct Answers:',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFcccbff),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    // Display correct answers here
                    ...questions
                        .asMap()
                        .entries
                        .map(
                          (entry) => Text(
                            'Q${entry.key + 1}: ${entry.value.correctAnswer}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xFFcccbff),
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
            // Display correct answers here
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
