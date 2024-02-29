import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../pages/quiz_page.dart';

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({
    super.key,
  });

  @override
  PracticePageState createState() => PracticePageState();
}

class PracticePageState extends ConsumerState<PracticePage> {
  final int _duration = 20;
  int _score = 0;
  final CountDownController _controller = CountDownController();

  int _currentQuestionIndex = 0;
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          "Choose the correct translation and usage of the Blackfoot word \"i\' poyít\" in a sentence",
      'options': [
        'After dinner, we will i\'poyít under the stars - Speak',
        'Please fetch some i\'poyít from the stream -  Water',
        'The i\'poyít is bright in the sky today -  Sun',
        'I saw a beautiful i\'poyít running across the field - Horse'
      ],
      'correctAnswer': 'After dinner, we will i\'poyít under the stars - Speak',
    },
    {
      'question': 'Which sentence uses "isstsííyik" correctly?',
      'options': [
        'Please isstsííyik to the river\'s flow. - Listen',
        'sstsííyik me a bedtime story. - Speak',
        'The isstsííyik feels warm today. - Sun',
        'I\'ll isstsííyik the book on the shelf. Place'
      ],
      'correctAnswer': 'Please isstsííyik to the river\'s flow. - Listen',
    },
    {
      'question':
          'Select the set where all Blackfoot words are correctly matched with their English meanings:',
      'options': [
        'tsimá - How?, takáá - Where?, tsa - Who?',
        'tsimá - Who?, takáá - How?, tsa - Where?',
        'tsimá - Where?, takáá - Who?, tsa - How?',
        'tsimá - Who?, takáá - Where?, tsa - How?'
      ],
      'correctAnswer': 'tsimá - Where?, takáá - Who?, tsa - How?',
    },
    {
      'question':
          'Imagine you\'re learning to cook a traditional dish with a Blackfoot-speaking elder. To ask about the process in their language, which word would you use?',
      'options': ['Why? (tsa)', 'How? (tsa)', 'When? (tsa)', 'What? (tsa)'],
      'correctAnswer': 'How? (tsa)',
    },
    // Add more questions as needed
  ];

  int _secondsRemaining = 10;
  bool _isAnswered = false;
  String _selectedAnswer = '';
  @override
  void initState() {
    super.initState();
    print("initState");
    _startTimer();
  }

  @override
  void didChangeDependencies() {
    _startTimer();
    super.didChangeDependencies();
  }

  void _startTimer() {
    // const oneSecond = Duration(seconds: 20);
    // _controller.start();
    // Timer.periodic(oneSecond, (timer) {
    //   if (_secondsRemaining == 0 || _isAnswered) {
    //     Future.delayed(Duration(seconds: 2), () => _nextQuestion());
    //     //_nextQuestion();
    //   } else {
    //     _controller.start();
    //     setState(() {
    //       _secondsRemaining--;
    //     });
    //   }
    // });
    print("startTimer");
    _controller.start();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _secondsRemaining = 10;
        _isAnswered = false;
        // _startTimer();
        _controller.restart();
      } else {
        // Navigate to result page or perform any desired action
        // For simplicity, let's just print the result for now
        print('Quiz completed!');
        _controller.reset();
        showAlertDilog();
      }
    });
  }

  void _selectAnswer(String selectedAnswer) {
    if (!_isAnswered) {
      setState(() {
        _isAnswered = true;
        _selectedAnswer = selectedAnswer;
      });

      if (selectedAnswer ==
          _questions[_currentQuestionIndex]['correctAnswer']) {
        //Future.delayed(Duration(seconds: 2), () => _nextQuestion());
        // _nextQuestion();
        _score++;
        print('Correct!');
      } else {
        // Handle incorrect answer
        print('Incorrect!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              )),
              elevation: 20,
              shadowColor: Color(0xffbdbcfd),
              child: Container(
                  height: 180,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Question ${_currentQuestionIndex + 1}:',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Container(
                            width: 350,
                            child: Text(
                              _questions[_currentQuestionIndex]['question'],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircularCountDownTimer(
                              duration: _duration,
                              initialDuration: 0,
                              controller: _controller,
                              width: MediaQuery.of(context).size.width / 8,
                              height: MediaQuery.of(context).size.height / 8,
                              ringColor: Colors.grey[300]!,
                              ringGradient: null,
                              fillColor: Color(0xffbdbcfd),
                              fillGradient: null,
                              backgroundColor: Colors.white,
                              backgroundGradient: null,
                              strokeWidth: 8.0,
                              strokeCap: StrokeCap.round,
                              textStyle: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xffbdbcfd),
                                  fontWeight: FontWeight.bold),
                              textFormat: CountdownTextFormat.S,
                              isReverse: true,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: false,
                              onStart: () {
                                debugPrint('Countdown Started');
                              },
                              onComplete: () {
                                debugPrint('Countdown Ended');
                              },
                              onChange: (String timeStamp) {
                                debugPrint('Countdown Changed $timeStamp');
                              },
                              timeFormatterFunction:
                                  (defaultFormatterFunction, duration) {
                                if (duration.inSeconds == 0) {
                                  return _duration.toString();
                                } else {
                                  return Function.apply(
                                      defaultFormatterFunction, [duration]);
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),

            SizedBox(height: 16.0),
            // Display options
            Column(
              children: List.generate(
                _questions[_currentQuestionIndex]['options'].length,
                (index) => RadioListTile(
                  title:
                      Text(_questions[_currentQuestionIndex]['options'][index]),
                  groupValue: _selectedAnswer,
                  value: _questions[_currentQuestionIndex]['options'][index],
                  onChanged: (value) => _selectAnswer(value),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isAnswered ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffbdbcfd),
                foregroundColor: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                fixedSize: Size(200.0, 50.0),
              ),
              child: _controller.isStarted ? Text('Next') : Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  void showAlertDilog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Quiz Completed"),
            content: Text("Your score is $_score. Do you want to play again?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentQuestionIndex = 0;
                      _isAnswered = false;
                    });

                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizPage()));
                  },
                  child: Text("Yes")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => QuizPage()));
                  },
                  child: Text("No")),
            ],
          );
        });
  }
}
