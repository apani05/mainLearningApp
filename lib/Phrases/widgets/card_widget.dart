import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/views/category_learning_page.dart';
import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardWidget extends ConsumerStatefulWidget {
  final int index;
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  final bool isPlaying;
  final VoidCallback onPlayButtonPressed;
  final VoidCallback onSavedButtonPressed;
  final String documentId;

  const CardWidget({
    super.key,
    required this.index,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.isPlaying,
    required this.onPlayButtonPressed,
    required this.onSavedButtonPressed,
    required this.documentId,
  });

  @override
  ConsumerState<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends ConsumerState<CardWidget> {
  @override
  Widget build(BuildContext context) {
    final player = ref.watch(audioPlayerProvider);
    final theme = ref.watch(themeProvider);
    final blogProviderObj = ref.watch(blogProvider);
    bool isPhraseSaved = blogProviderObj
        .getUserPhraseProgress()
        .savedPhrases
        .any((phrase) => phrase.documentId == widget.documentId);
    return Card(
      color: theme.lightPurple,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.englishText,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // THE HEART ICON // SAVE BUTTON FOR BLOG
                IconButton(
                  onPressed: widget.onSavedButtonPressed,
                  icon: Icon(
                    isPhraseSaved ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                ), // Heart icon
              ],
            ),
            const Divider(
              color: Colors.white,
              thickness: 1,
              height: 16,
              indent: 0,
              endIndent: 0,
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.blackfootText,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    widget.onPlayButtonPressed();
                    playAudio(widget.blackfootAudio, player, widget.isPlaying);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        widget.isPlaying ? theme.red : Colors.white,
                  ),
                  icon: Icon(
                    widget.isPlaying ? Icons.stop : Icons.volume_up,
                    color: widget.isPlaying ? Colors.white : theme.lightPurple,
                  ),
                  label: const Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
