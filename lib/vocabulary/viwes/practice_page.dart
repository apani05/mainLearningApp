import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/vocabulary/model/quiz_model.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../../riverpod/river_pod.dart';

class PracticePage extends ConsumerStatefulWidget {
  final String category;
  const PracticePage({
    super.key,
    required this.category,
  });

  @override
  PracticePageState createState() => PracticePageState();
}

class PracticePageState extends ConsumerState<PracticePage> {
  final int _duration = 20;
  int _score = 0;
  final CountDownController _controller = CountDownController();

  int _currentQuestionIndex = 0;

  List<QuizQuestion> _questions = [];

  int _secondsRemaining = 10;
  bool _isAnswered = false;
  String _selectedAnswer = '';
  @override
  void initState() {
    super.initState();
    fetchQuestions();
    print("initState");
  }

  fetchQuestions() async {
    _questions = await ref.read(vocaProvider).fetchQuestions(widget.category);
    print("questions are $_questions");
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _secondsRemaining = 10;
        _isAnswered = false;
        // _startTimer();
        //_controller.restart();
      } else {
        // Navigate to result page or perform any desired action
        // For simplicity, let's just print the result for now
        print('Quiz completed!');
        //  _controller.reset();
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

      // ref.read(vocaProvider).selectAnswer(selectedAnswer);
      if (selectedAnswer == _questions[_currentQuestionIndex].correctAnswer) {
        //Future.delayed(Duration(seconds: 2), () => _nextQuestion());
        // _nextQuestion();
        _score++;
        print('Correct!');
      } else {
        // Handle incorrect answer
        print('Incorrect!');
      }
      bool isCorrect =
          selectedAnswer == _questions[_currentQuestionIndex].correctAnswer;
      Color backgroundColor = isCorrect ? Colors.green : Colors.red;
      String message = isCorrect ? 'Correct!' : 'Incorrect!';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: isCorrect
                ? Text(message)
                : Text(
                    message +
                        "\nCorrect Answer is ${_questions[_currentQuestionIndex].correctAnswer}",
                    style: TextStyle(color: Colors.white)),
            backgroundColor: backgroundColor,
            duration: Duration(days: 365),
            action: SnackBarAction(
              label: 'Next',
              onPressed: () {
                _nextQuestion();
              },
            )),
      );

      if (isCorrect) {
        _score++;
        print('Correct!');
      } else {
        print('Incorrect!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final vocaProvide = ref.read(vocaProvider);
    FirebaseStorage storage = FirebaseStorage.instance;
    Widget body;
    if (_questions.isEmpty) {
      body = Center(child: CircularProgressIndicator());
    } else {
      if (_questions[_currentQuestionIndex].quizType == '1') {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Tap the audio. What does the word represent ?",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 26.0),
              GestureDetector(
                onTap: () async {
                  AudioPlayer audioPlayer = AudioPlayer();
                  print(_questions[_currentQuestionIndex]);
                  print(
                      "sound to be played ${_questions[_currentQuestionIndex].sound}");
                  Uri downloadUrl = Uri.parse(await storage
                      .refFromURL(_questions[_currentQuestionIndex].sound)
                      .getDownloadURL());
                  await audioPlayer.play(UrlSource(downloadUrl.toString()));
                },
                child: Center(
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                        // child: vocaProvide.isDownloading?
                        // Lottie.asset("assets/heart.json"):
                        child: Lottie.network(
                      _questions[_currentQuestionIndex].audioLottie,
                      height: 180,
                      width: 180,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
              SizedBox(height: 26.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatefulBuilder(builder: (context, StateSetter setState) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAnswered
                            ? _questions[_currentQuestionIndex].correctAnswer ==
                                    _questions[_currentQuestionIndex]
                                        .options![0]
                                        .word!
                                ? Colors.green
                                : _selectedAnswer ==
                                        _questions[_currentQuestionIndex]
                                            .options![0]
                                            .word!
                                    ? Colors.red
                                    : null
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        maximumSize: Size(180, 120),
                        minimumSize: Size(180, 120),
                      ),
                      onPressed: () {
                        _selectAnswer(
                            _questions[_currentQuestionIndex].options[0].word);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                              height: 100,
                              width: 100,
                              child: Lottie.network(
                                  _questions[_currentQuestionIndex]
                                      .options[0]
                                      .lottie)),
                          Text(_questions[_currentQuestionIndex]
                              .options[0]
                              .word),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? _questions[_currentQuestionIndex].correctAnswer ==
                                  _questions[_currentQuestionIndex]
                                      .options![1]
                                      .word!
                              ? Colors.green
                              : _selectedAnswer ==
                                      _questions[_currentQuestionIndex]
                                          .options![1]
                                          .word!
                                  ? Colors.red
                                  : null
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      maximumSize: Size(180, 120),
                      minimumSize: Size(180, 120),
                    ),
                    onPressed: () {
                      _selectAnswer(
                          _questions[_currentQuestionIndex].options![1].word!);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.network(
                                _questions[_currentQuestionIndex]
                                    .options![1]
                                    .lottie!)),
                        Text(_questions[_currentQuestionIndex].options[1].word),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAnswered
                          ? _questions[_currentQuestionIndex].correctAnswer ==
                                  _questions[_currentQuestionIndex]
                                      .options![2]
                                      .word
                              ? Colors.green
                              : _selectedAnswer ==
                                      _questions[_currentQuestionIndex]
                                          .options![2]
                                          .word
                                  ? Colors.red
                                  : null
                          : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      maximumSize: Size(180, 120),
                      minimumSize: Size(180, 120),
                    ),
                    onPressed: () {
                      _selectAnswer(
                          _questions[_currentQuestionIndex].options![2].word!);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.network(
                                _questions[_currentQuestionIndex]
                                    .options![2]
                                    .lottie!)),
                        Text(_questions[_currentQuestionIndex]
                            .options![2]
                            .word!),
                      ],
                    ),
                  ),
                  SizedBox(height: 25.0),
                ],
              ),
            ],
          ),
        );
      } else if (_questions[_currentQuestionIndex].quizType == '2') {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0),
            Text(
              "${_questions[_currentQuestionIndex].question}",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return LWidget(
                url: _questions[_currentQuestionIndex].options![0].lottie!,
                text: _questions[_currentQuestionIndex].options![0].word!,
                isAnswered: _isAnswered,
                selectedAnswer: _selectedAnswer,
                correctAnswer: _questions[_currentQuestionIndex].correctAnswer,
                onTap: _selectAnswer,
                soundUrl: _questions[_currentQuestionIndex].options![0].sound!,
              );
            }),
            SizedBox(height: 16.0),
            StatefulBuilder(builder: (context, StateSetter setState) {
              return LWidget(
                url: _questions[_currentQuestionIndex].options![1].lottie!,
                text: _questions[_currentQuestionIndex].options![1].word!,
                isAnswered: _isAnswered,
                selectedAnswer: _selectedAnswer,
                correctAnswer: _questions[_currentQuestionIndex].correctAnswer,
                onTap: _selectAnswer,
                soundUrl: _questions[_currentQuestionIndex].options![1].sound!,
              );
            }),
            SizedBox(height: 16.0),
            LWidget(
              url: _questions[_currentQuestionIndex].options![2].lottie!,
              text: _questions[_currentQuestionIndex].options![2].word!,
              isAnswered: _isAnswered,
              selectedAnswer: _selectedAnswer,
              correctAnswer: _questions[_currentQuestionIndex].correctAnswer,
              onTap: _selectAnswer,
              soundUrl: _questions[_currentQuestionIndex].options![2].sound!,
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 26.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_questions[_currentQuestionIndex].question}",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 36.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: normalOption(
                          _questions[_currentQuestionIndex].options![0].word!,
                          _questions[_currentQuestionIndex].correctAnswer),
                    ),
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: normalOption(
                          _questions[_currentQuestionIndex].options![1].word!,
                          _questions[_currentQuestionIndex].correctAnswer),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: normalOption(
                          _questions[_currentQuestionIndex].options![2].word!,
                          _questions[_currentQuestionIndex].correctAnswer),
                    ),
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: normalOption(
                          _questions[_currentQuestionIndex].options![3].word!,
                          _questions[_currentQuestionIndex].correctAnswer),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }
      // body = CircularProgressIndicator();
    }
    return Scaffold(
      body: body,
    );
  }

  void showCustomLottieSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Row(
        children: [
          Lottie.asset('assets/1st-place.json',
              width: 40), // Path to your Lottie file
          Expanded(
            child: Text(
              'This is a custom snackbar with Lottie!',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      duration: Duration(days: 365),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Widget LWidget(
      {required String url,
      required String text,
      required bool isAnswered,
      required String selectedAnswer,
      required correctAnswer,
      required void Function(String selectedAnswer) onTap,
      required String soundUrl}) {
    return Center(
      child: Stack(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isAnswered
                  ? correctAnswer == text
                      ? Colors.green
                      : selectedAnswer == text
                          ? Colors.red
                          : null
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              maximumSize: Size(380, 150),
              minimumSize: Size(380, 150),
            ),
            onPressed: () {
              onTap(text);
            },
            child: Column(
              children: [
                SizedBox(height: 100, width: 100, child: Lottie.network(url)),
                Text(text),
              ],
            ),
          ),
          Positioned(
              top: 20,
              right: 20,
              child: GestureDetector(
                onTap: () async {
                  // play audio
                  // final vocaProvide = ref.read(vocaProvider);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  //  vocaProvide.isDownloading = true;
                  //  print("${vocaProvide.isDownloading} is downloading");
                  AudioPlayer audioPlayer = AudioPlayer();
                  print(soundUrl);
                  Uri downloadUrl = Uri.parse(
                      await storage.refFromURL(soundUrl).getDownloadURL());
                  //   vocaProvide.isDownloading = false;
                  // Play the audio using the audioplayers package
                  await audioPlayer.play(UrlSource(downloadUrl.toString()));
                  //   print("${vocaProvide.isDownloading} is downloading");
                },
                child: Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                        child: Icon(
                      Icons.volume_up,
                      size: 30,
                      color: Colors.black,
                    )),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  normalOption(String s, question) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _isAnswered
            ? question == s
                ? Colors.green
                : _selectedAnswer == s
                    ? Colors.red
                    : null
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        maximumSize: Size(180, 120),
        minimumSize: Size(180, 120),
      ),
      onPressed: () {
        _selectAnswer(s);
      },
      child: Center(
        child: Text(s),
      ),
    );
  }
}
