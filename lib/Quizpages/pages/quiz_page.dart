import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/models/question_model.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Phrases/provider/mediaProvider.dart';
import '../../riverpod/river_pod.dart';
import 'quiz_result_page.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int _currentIndex = 0;
  List<Question> quizQuestions = [];
  late List<bool> _isQuestionAnswered;
  bool _isNextButtonEnabled = false;
  bool _isSubmitButtonEnabled = false;
  List<String> selectedSeries = [];
  late AudioPlayer player = ref.watch(audioPlayerProvider);
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isQuestionAnswered = [];
    _showSeriesSelectionDialog();
  }

  Future<void> _showSeriesSelectionDialog() async {
    List<Map<String, dynamic>> seriesOptions =
        await ref.read(blogProvider).getSeriesOptions();
    List<bool> isSelected =
        List.generate(seriesOptions.length, (index) => false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Select Series"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Scrollbar(
              trackVisibility: true,
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    children: seriesOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> seriesMap = entry.value;
                      String series = seriesMap['seriesName'];
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
                  ),
                ),
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              selectedSeries = [];
              for (int i = 0; i < isSelected.length; i++) {
                if (isSelected[i]) {
                  selectedSeries.add(seriesOptions[i]['seriesName']);
                }
              }
              if (selectedSeries.isNotEmpty) {
                fetchQuestionsForSelectedSeries();
                Navigator.pop(context);
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> fetchQuestionsForSelectedSeries() async {
    try {
      List<Question> audioQuestions = [];
      List<Question> textQuestions = [];

      selectedSeries.forEach((series) {
        List<CardData> cardsForSeries =
            ref.read(blogProvider).filterDataBySeriesName(series);

        cardsForSeries.forEach((card) {
          if (card.blackfootText.isEmpty) {
            return;
          }

          List<String> allBlackfootTexts = cardsForSeries
              .where((c) =>
                  c.blackfootText != card.blackfootText &&
                  c.blackfootText.isNotEmpty)
              .map((c) => c.blackfootText)
              .toList();

          allBlackfootTexts.shuffle();
          List<String> options = [
            card.blackfootText,
            ...allBlackfootTexts.take(3)
          ];
          options.shuffle();

          Question questionCard = Question(
            questionText: '${card.englishText}| ${card.blackfootAudio}',
            correctAnswer: card.blackfootText,
            options: options,
            isAudioTypeQuestion: cardsForSeries.indexOf(card) % 2 == 0,
            seriesType: card.seriesName,
          );

          if (questionCard.isAudioTypeQuestion) {
            audioQuestions.add(questionCard);
          } else {
            textQuestions.add(questionCard);
          }
        });
      });

      audioQuestions.shuffle();
      textQuestions.shuffle();

      int numberOfQuestionsToKeep =
          audioQuestions.length + textQuestions.length < 10
              ? audioQuestions.length + textQuestions.length
              : 10;

      List<Question> selectedQuestions = [];
      selectedQuestions
          .addAll(audioQuestions.take(numberOfQuestionsToKeep ~/ 2));
      selectedQuestions
          .addAll(textQuestions.take(numberOfQuestionsToKeep ~/ 2));
      selectedQuestions.shuffle();

      setState(() {
        quizQuestions = selectedQuestions;
        _isQuestionAnswered =
            List.generate(quizQuestions.length, (index) => false);
      });
    } catch (error) {
      print("Error fetching questions: $error");
    }
  }

  void nextQuestion() async {
    if (isPlaying) {
      await player.stop();
    }
    isPlaying = false;
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

    final leaderboardRepo = ref.watch(leaderboardProvider);
    final userRepo = ref.watch(userProvider);
    userRepo.updateScore(userRepo.uid, quizScore);
    leaderboardRepo.addToLeaderBoard(userRepo.name, quizScore);

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

  Future<void> _onBackPressed(bool didPop) async {
    if (!didPop && _currentIndex < quizQuestions.length) {
      bool shouldExit = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Exit Quiz?"),
          content: const Text("Are you sure you want to exit the quiz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (isPlaying) {
                  await player.stop();
                }
                isPlaying = false;
                Navigator.of(context).pop(true);
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
          ],
        ),
      );

      if (shouldExit) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PopScope(
        canPop: true,
        onPopInvoked: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                if (mounted) {
                  _onBackPressed(false);
                }
              },
            ),
            title: const Text(
              'Quiz',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: purpleLight,
          ),
          body: Column(
            children: [
              Image.asset(
                'assets/quiz_image.jpg',
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _currentIndex < quizQuestions.length
                          ? buildQuestionCard(quizQuestions[_currentIndex])
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: purpleLight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1} of ${quizQuestions.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isNextButtonEnabled ? nextQuestion : null,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: purpleLight),
                    child: const Text("Next"),
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
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.isAudioTypeQuestion
                  ? "Match the audio with the corresponding blackfoot text?"
                  : "Select Blackfoot Translation for: ${question.questionText.split('|')[0]}",
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: purpleLight,
              ),
            ),
            const Text('Select answer and scroll down to check answer!'),
            if (question.isAudioTypeQuestion) const SizedBox(height: 15.0),
            if (question.isAudioTypeQuestion)
              ElevatedButton.icon(
                onPressed: () {
                  playAudio(
                      question.questionText.split('|')[1], player, isPlaying);
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPlaying ? red : Colors.white,
                ),
                icon: Icon(
                  isPlaying ? Icons.stop : Icons.volume_up,
                  color: isPlaying ? Colors.white : purpleLight,
                ),
                label: const Text(''),
              ),
            SizedBox(height: question.isAudioTypeQuestion ? 0 : 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildRadioOptionsList(question.options),
            ),
            if (question.showCorrectAnswer)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Correct Answer: ${question.correctAnswer}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: green,
                  ),
                ),
              ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed:
                  _isSubmitButtonEnabled ? () => submitAnswer(question) : null,
              style: ElevatedButton.styleFrom(backgroundColor: purpleLight),
              child: const Text("Check Answer"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRadioOptionsList(List<String> options) {
    return options.map((option) {
      return RadioListTile<String>(
        title: Text(
          option,
          style: const TextStyle(fontSize: 18.0, color: Colors.black),
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
        activeColor: purpleLight,
      );
    }).toList();
  }
}
