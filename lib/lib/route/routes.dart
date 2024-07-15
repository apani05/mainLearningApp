//write code for route here
import 'package:bfootlearn/Disscussion/viwes/disscusion_page.dart';
import 'package:bfootlearn/Home/views/home_view.dart';
import 'package:bfootlearn/leaderboard/views/leader_board_page.dart';
import 'package:bfootlearn/vocabulary/viwes/v_game.dart';
import 'package:bfootlearn/vocabulary/viwes/vocabulary_home.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String homeRoute = '/home';
  static const String feedRoute = '/feed';
  static const String leaderboardRoute = '/leaderboard';
  static const String disscussionRoute = '/discussion';
  static const vocabularyRoute = '/vocabulary';
  static const String vGame = '/vgames';
  static const String blogRoute = '/blog';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (context) => HomeView());
      case leaderboardRoute:
        return MaterialPageRoute(builder: (context) => LeaderBoardPage());
      case disscussionRoute:
        return MaterialPageRoute(builder: (context) => DisscussionPage());
      case vocabularyRoute:
        return MaterialPageRoute(builder: (context) => VocabularyHome());
        case vGame:
        final args = settings.arguments as Map<String, String>;
        return MaterialPageRoute(builder: (context) => VocabularyGame( category: args['category']!, uid: args['uid']! ,));
      default:
        return MaterialPageRoute(builder: (context) => HomeView());
    }
  }
}
