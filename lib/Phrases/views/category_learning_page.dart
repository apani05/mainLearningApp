import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/widgets/card_slider.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:bfootlearn/vocabulary/viwes/v_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;
  final List<CardData> data;
  final bool isVocabPresent;

  const LearningPage({
    super.key,
    required this.seriesName,
    required this.data,
    required this.isVocabPresent,
  });

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  int? currentPlayingIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final blogProviderObj = ref.watch(blogProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: customAppBar(context: context, title: widget.seriesName),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Background2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: widget.data.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: CardSlider(
                        cardDataList: widget.data,
                        currentPlayingIndex: currentPlayingIndex,
                        onSavedButtonPressed: (index) {
                          blogProviderObj.toggleSavedPhrase(widget.data[index]);
                        },
                        onPlayButtonPressed: (index) {
                          setState(() {
                            if (currentPlayingIndex == index) {
                              currentPlayingIndex = null;
                            } else {
                              currentPlayingIndex = index;
                            }
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: widget.isVocabPresent
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VocabularyGame(
                                      category: widget.seriesName,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 32.0,
                                ),
                                backgroundColor: const Color(0xFFcccbff),
                              ),
                              child:
                                  const Text('Explore related vocabularies?'),
                            )
                          : null,
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
