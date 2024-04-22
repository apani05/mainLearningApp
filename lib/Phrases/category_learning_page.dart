import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/provider/blogProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/river_pod.dart';
import 'card_slider.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;
  final List<CardData> data;

  const LearningPage({
    super.key,
    required this.seriesName,
    required this.data,
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
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.seriesName),
          backgroundColor: theme.lightPurple,
        ),
        body: widget.data.isNotEmpty
            ? CardSlider(
                cardDataList: widget.data,
                currentPlayingIndex: currentPlayingIndex,
                onSavedButtonPressed: (index) {
                  blogProviderObj.toggleSavedStatus(widget.data, index);
                },
                onPlayButtonPressed: (index) {
                  setState(() {
                    if (currentPlayingIndex == index) {
                      // Stop if the same button is pressed again
                      currentPlayingIndex = null;
                    } else {
                      // Play the clicked audio
                      currentPlayingIndex = index;
                    }
                  });
                },
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
