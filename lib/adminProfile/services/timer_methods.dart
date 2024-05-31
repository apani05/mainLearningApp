import 'dart:async';

import 'package:bfootlearn/adminProfile/services/flutter_sound_methods.dart';
import 'package:flutter/material.dart';

class TimerServiceProvider extends ChangeNotifier {
  Duration duration = const Duration();
  Duration countDownDuration = const Duration();
  Timer? timer;
  FlutterSoundMethods soundMethods = FlutterSoundMethods();

  Duration get getDuration => duration;

  void minusTimer() {
    const minusSeconds = 1;
    if (duration.inSeconds != 0) {
      final seconds = duration.inSeconds - minusSeconds;
      duration = Duration(seconds: seconds);
    } else {
      duration = countDownDuration;
      stopTimer();
    }
    notifyListeners();
  }

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

  void stopTimer() {
    if (soundMethods.isRecordingStopped) {
      countDownDuration = duration;
      timer!.cancel();
    } else {
      timer!.cancel();
    }
    notifyListeners();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void startCountDownTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => minusTimer());
  }
}
