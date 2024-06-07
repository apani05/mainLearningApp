import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/widgets/card_widget.dart';
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
                documentId: cardDataList[index].documentId,
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
      ],
    );
  }
}
