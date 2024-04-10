import 'package:bfootlearn/Phrases/card_widget.dart';
import 'package:bfootlearn/Phrases/provider/blogProvider.dart';
import 'package:bfootlearn/pages/quiz_page.dart';
import 'package:flutter/material.dart';

class CardSlider extends StatelessWidget {
  final List<CardData> cardDataList;
  final int? currentPlayingIndex;
  final Function(int) onPlayButtonPressed;
  final Function(int) onSavedButtonPressed;

  const CardSlider({
    super.key,
    required this.cardDataList,
    required this.currentPlayingIndex,
    required this.onPlayButtonPressed,
    required this.onSavedButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return CardWidget(
                index: index,
                englishText: cardDataList[index].englishText,
                blackfootText: cardDataList[index].blackfootText,
                blackfootAudio: cardDataList[index].blackfootAudio,
                isSaved: cardDataList[index].isSaved,
                isPlaying: currentPlayingIndex == index,
                onPlayButtonPressed: () {
                  onPlayButtonPressed(index);
                },
                onSavedButtonPressed: () {
                  onSavedButtonPressed(index);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuizPage(),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return const Color(0xFFcccbff);
                },
              ),
            ),
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }
}
