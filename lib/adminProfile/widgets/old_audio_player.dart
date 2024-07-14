import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/adminProfile/widgets/existing_conversations_listview.dart';
import 'package:flutter/material.dart';

class OldAudioPlayer extends StatefulWidget {
  final String oldBlackfootAudioPath;

  const OldAudioPlayer({
    super.key,
    required this.oldBlackfootAudioPath,
  });

  @override
  State<OldAudioPlayer> createState() => _OldAudioPlayerState();
}

class _OldAudioPlayerState extends State<OldAudioPlayer> {
  final AudioPlayer audioPlayer = AudioPlayer();
  void onPressedAudioButton() async {
    debugPrint(widget.oldBlackfootAudioPath);
    await audioPlayer
        .play(UrlSource(convertGsUrlToHttp(widget.oldBlackfootAudioPath)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: onPressedAudioButton,
            icon: const Icon(Icons.volume_up_rounded),
            iconSize: 25,
            color: Color(0xff6562df),
          ),
          const Text(
            'Old Blackfoot Audio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
