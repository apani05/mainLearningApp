import 'package:bfootlearn/leaderboard/repo/leaderboard_repo.dart';
import 'package:bfootlearn/notifications/notification_provider.dart';
import 'package:bfootlearn/theme.dart/theme.dart';
import 'package:bfootlearn/vocabulary/provider/voca_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../User/user_provider.dart';

final themeProvider = ChangeNotifierProvider((ref) {
  return ThemeNotifier();
});
final vocaProvider = ChangeNotifierProvider((ref) {
  return vocabularyProvider();
});
final leaderboardProvider = ChangeNotifierProvider((ref) {
  return LeaderBoardRepo();
});
final userProvider = ChangeNotifierProvider((ref) {
  return UserProvider();
});

final notificationProvider = ChangeNotifierProvider((ref) {
  return NotificationProvider()..loadSettings();
});
