//write code for route here
import 'package:bfootlearn/Disscussion/viwes/disscusion_page.dart';
import 'package:bfootlearn/Home/views/home_page.dart';
import 'package:bfootlearn/leaderboard/views/leader_board_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static const String homeRoute = '/home';
  static const String feedRoute = '/feed';
  static const String leaderboardRoute = '/leaderboard';
  static const String disscussionRoute = '/discussion';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (context) => HomePage());
      case leaderboardRoute:
        return MaterialPageRoute(builder: (context) => LeaderBoardPage());
      case disscussionRoute:
        return MaterialPageRoute(builder: (context) => DisscussionPage());
      default:
        return MaterialPageRoute(builder: (context) => HomePage());
    }
  }
}
