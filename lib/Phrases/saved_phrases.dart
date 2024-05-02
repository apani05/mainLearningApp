import 'package:bfootlearn/Phrases/widgets/card_slider.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {
  int? currentPlayingIndex;

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final blogProviderObj = ref.watch(blogProvider);
    final savedBlogs = blogProviderObj.getUserPhraseProgress().savedPhrases;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Saved Blogs"),
        backgroundColor: theme.lightPurple,
      ),
      body: savedBlogs.isEmpty
          ? const Center(
              child: Text('No Saved Blogs'),
            )
          : CardSlider(
              cardDataList: savedBlogs,
              currentPlayingIndex: currentPlayingIndex,
              onSavedButtonPressed: (index) {
                blogProviderObj.toggleSavedPhrase(savedBlogs[index]);
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
            ),
    );
  }
}
