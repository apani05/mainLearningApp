import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecordingAudioContainer extends ConsumerStatefulWidget {
  const RecordingAudioContainer({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RecordingAudioContainerState();
}

class _RecordingAudioContainerState
    extends ConsumerState<RecordingAudioContainer> {
  final audioRecorder = FlutterSoundMethods();

  Future onPressedRecordButton() async {
    if (audioRecorder.isRecorderInitialised) {
      if (audioRecorder.isRecording) {
        // initial state
        debugPrint(
            "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
        await audioRecorder.stopRecording();
      } else {
        if (audioRecorder.isPlayerInitialised) {
          if (audioRecorder.isPlaying) {
            debugPrint(
                "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
            // playing state
            await audioRecorder.pausePlaying();
          } else {
            debugPrint(
                "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
            // paused state
            await audioRecorder.resumePlaying();
          }
        } else {
          debugPrint(
              "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
          await audioRecorder.startPlaying();
        }
      }
    } else {
      debugPrint(
          "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
      // recording state
      await audioRecorder.startRecording();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    try {
      await audioRecorder.init(context: context);
    } catch (e) {
      debugPrint('Failed to initialize the audio recorder: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    audioRecorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isRecording = audioRecorder.isRecording;
    bool isPlaying = audioRecorder.isPlaying;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Record Blackfoot Audio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onPressedRecordButton,
                icon: audioRecorder.isRecorderInitialised
                    ? isRecording
                        ? const Icon(
                            Icons.stop_circle_outlined,
                            size: 35,
                            color: Colors.red,
                          )
                        : audioRecorder.isPlayerInitialised
                            ? Icon(
                                isPlaying
                                    ? Icons.pause_circle_outlined
                                    : Icons.play_circle_outline_rounded,
                                size: 35,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.play_circle_outline_rounded,
                                size: 35,
                                color: Colors.black,
                              )
                    : micIcon(),
              ),
              const Spacer(),
              if (audioRecorder.isRecorderInitialised &&
                  audioRecorder.isRecordingStopped)
                IconButton(
                  onPressed: () {
                    setState(() {
                      audioRecorder.dispose();
                    });
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 25,
                  ),
                )
            ],
          )
        ],
      ),
    );
  }

  Widget micIcon() {
    return Container(
      margin: const EdgeInsets.all(0),
      height: 35,
      width: 35,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.mic_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

TextStyle timerTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);
