import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

Future<void> playAudio(
    String audioUrl, AudioPlayer player, bool isPlaying) async {
  try {
    audioUrl = audioUrl.trim();
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

Future<String> getImageUrl(String imageUrl) async {
  String downloadUrl =
      await FirebaseStorage.instance.refFromURL(imageUrl).getDownloadURL();
  print('downloadUrl: $downloadUrl');
  return downloadUrl;
}
