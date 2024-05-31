import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:bfootlearn/adminProfile/services/timer_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RecordingAudioContainer extends ConsumerStatefulWidget {
//   const RecordingAudioContainer({super.key});
//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _RecordingAudioContainerState();
// }
// class _RecordingAudioContainerState extends ConsumerState<RecordingAudioContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

final timerServiceProvider =
    ChangeNotifierProvider((ref) => TimerServiceProvider());

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

  // late bool isPlayingInitiated;

  Future onPressedRecordButton() async {
    final timerService = ref.watch(timerServiceProvider);
    if (audioRecorder.isRecorderInitialised) {
      if (audioRecorder.isRecording) {
        // initial state
        debugPrint(
            "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
        await audioRecorder.stopRecording();

        // stops the timer
        timerService.stopTimer();
      } else {
        if (audioRecorder.isPlayerInitialised) {
          if (audioRecorder.isPlaying) {
            debugPrint(
                "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
            // playing state
            await audioRecorder.pausePlaying();

            // stops timer
            timerService.stopTimer();
          } else {
            debugPrint(
                "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
            // paused state
            await audioRecorder.resumePlaying();

            // restarts countdown timer
            timerService.startCountDownTimer();
          }
        } else {
          debugPrint(
              "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
          await audioRecorder.startPlaying();

          // starts countdown timer
          timerService.startCountDownTimer();
        }
      }
    } else {
      debugPrint(
          "isRecording : ${audioRecorder.isRecording}, isRecordingStopped: ${audioRecorder.isRecordingStopped}, isPlaying: ${audioRecorder.isPlaying}, isPlayerIni: ${audioRecorder.isPlayerInitialised}");
      // recording state
      await audioRecorder.startRecording();
      // starts the timer
      timerService.startTimer();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // isPlayingInitiated = false;
    audioRecorder.init();
  }

  @override
  void dispose() {
    super.dispose();
    audioRecorder.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerService = ref.watch(timerServiceProvider);
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
            'Record Blackfoot audio',
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
              Text(
                formatDuration(timerService.duration),
                style: timerTextStyle,
              ),
              const Spacer(),
              if (audioRecorder.isPlayerInitialised)
                IconButton(
                  onPressed: () {
                    setState(() {
                      audioRecorder.dispose();
                      timerService.resetTimerForRecorder();
                    });
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 35,
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
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

String formatDuration(Duration d) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
  return "$twoDigitMinutes:$twoDigitSeconds";
}
