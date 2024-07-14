import 'dart:async';

class AppUsageService {
  late Timer _timer;
  late StreamController<int> _usageTimeController;
  late Stream<int> _usageTimeStream;
  int _appUsageTimeInSeconds = 0;

  Stream<int> get usageTimeStream => _usageTimeStream;

  AppUsageService() {
    _usageTimeController = StreamController<int>();
    _usageTimeStream = _usageTimeController.stream;
    _startTimer();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      _appUsageTimeInSeconds++;
      _usageTimeController.add(_appUsageTimeInSeconds);
    });
  }

  void dispose() {
    _timer.cancel();
    _usageTimeController.close();
  }
}
