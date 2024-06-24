import 'dart:async';

import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:flutter/material.dart';

class TimerServiceProvider extends ChangeNotifier {
  Duration duration = const Duration();
  Duration countDownDuration = const Duration();
  Duration stoppingTime = const Duration();
  Timer? timer;
  FlutterSoundMethods soundMethods = FlutterSoundMethods();

  Duration get getDuration => duration;

  void resetTimerForRecorder() {
    duration = Duration.zero;
    timer!.cancel();
    notifyListeners();
  }

  void addTime() {
    const addSeconds = 1;
    final seconds = duration.inSeconds + addSeconds;
    duration = Duration(seconds: seconds);
    notifyListeners();
  }

  // New method to add seconds to the timer until it reaches the maximum time
  void incrementTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (duration < stoppingTime) {
        addTime();
      } else {
        timer!.cancel();
        duration = Duration.zero;
        notifyListeners();
      }
    });
  }

  void stopTimerForRecording() {
    timer!.cancel();
    stoppingTime = duration;
    duration = Duration.zero;
    notifyListeners();
  }

  void pauseTimerForPlaying() {
    timer!.cancel();
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }
}
