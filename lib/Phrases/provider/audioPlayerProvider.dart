import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

Future<void> playAudio(BuildContext context, String audioUrl,
    AudioPlayer player, bool isPlaying) async {
  try {
    Uri downloadUrl = Uri.parse(
        await FirebaseStorage.instance.refFromURL(audioUrl).getDownloadURL());
    await player.stop();
    if (!isPlaying) {
      await player.play(UrlSource(downloadUrl.toString()));
    }
  } catch (e) {
    print('Error in audio player: $e');
  }
}
