import 'package:bfootlearn/leaderboard/repo/leaderboard_repo.dart';
import 'package:bfootlearn/notifications/notification_provider.dart';
import 'package:bfootlearn/theme.dart/theme.dart';
import 'package:bfootlearn/vocabulary/provider/voca_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Phrases/provider/blogProvider.dart';
import '../Disscussion/provider/disscuss_provider.dart';
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
final blogProvider = ChangeNotifierProvider<BlogProvider>((ref) {
  return BlogProvider();
});
final notificationProvider = ChangeNotifierProvider((ref) {
  return NotificationProvider()..loadSettings();
});
final dissCussionProvider = ChangeNotifierProvider((ref) {
  return FirestoreDiscussProvider();
});

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

final scoreProvider = StateProvider<int>((ref) => 0);