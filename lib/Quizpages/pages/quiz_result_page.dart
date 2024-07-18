import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/models/question_model.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Phrases/provider/mediaProvider.dart';
import '../widgets/circular_graph.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final int quizScore;
  final List<Question> quizQuestions;

  const QuizResultScreen({
    Key? key,
    required this.quizScore,
    required this.quizQuestions,
  }) : super(key: key);

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  late AudioPlayer player = ref.watch(audioPlayerProvider);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              if (mounted) {
                player.stop();
                Navigator.pop(context);
              }
            },
          ),
          title: const Text(
            'Quiz Result',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: purpleLight,
        ),
        body: _buildQuizResultContent(screenWidth),
      ),
    );
  }

  Widget _buildQuizResultContent(double screenWidth) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/Background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.bold,
                    color: purpleDark,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                CircularGraph(
                  quizScore: widget.quizScore,
                  totalQuestions: widget.quizQuestions.length,
                ),
                SizedBox(height: screenWidth * 0.04),
                Text(
                  'You answered ${widget.quizScore} out of ${widget.quizQuestions.length} questions correctly.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: purpleDark,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  'Correct Answers:',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: purpleDark,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                ...widget.quizQuestions
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value.isAudioTypeQuestion
                                  ? "Q${entry.key + 1}: Match the audio with the corresponding Blackfoot text?"
                                  : 'Q${entry.key + 1}: ${entry.value.questionText.split('|')[0]}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: purpleDark,
                              ),
                            ),
                            if (entry.value.isAudioTypeQuestion)
                              SizedBox(height: screenWidth * 0.02),
                            if (entry.value.isAudioTypeQuestion)
                              ElevatedButton.icon(
                                onPressed: () {
                                  playAudio(
                                      entry.value.questionText.split('|')[1],
                                      player,
                                      false);
                                },
                                icon: const Icon(
                                  Icons.volume_up,
                                  color: purpleDark,
                                ),
                                label: const Text(''),
                              ),
                            SizedBox(height: screenWidth * 0.02),
                            if (entry.value.selectedAnswer !=
                                entry.value.correctAnswer)
                              Text(
                                'Your Answer: ${entry.value.selectedAnswer}',
                                style: TextStyle(
                                    fontSize: screenWidth * 0.035, color: red),
                              ),
                            Text(
                              'Correct Answer: ${entry.value.correctAnswer}',
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: green,
                              ),
                            ),
                            SizedBox(height: screenWidth * 0.04),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
