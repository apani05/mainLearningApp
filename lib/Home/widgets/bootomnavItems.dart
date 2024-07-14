import 'package:bfootlearn/Disscussion/viwes/disscusion_page.dart';
import 'package:bfootlearn/leaderboard/views/leader_board_page.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_page.dart';

class BottomNavItem {
  static bottomBar(WidgetRef ref, ThemeData theme) {
    final vProvider = ref.watch(vocaProvider);
    final theme = ref.watch(themeProvider);
    return CurvedNavigationBar(
      backgroundColor:
          vProvider.currentPage == 1 ? Color(0xFFb9bdbe) : Colors.white,
      key: vProvider.bottomNavigationKey,
      color: theme.lightPurple,
      items: <Widget>[
        Icon(Icons.home,
            size: 30,
            color: vProvider.currentPage == 0 ? Colors.white : Colors.grey),
        Icon(Icons.leaderboard,
            size: 30,
            color: vProvider.currentPage == 1 ? Colors.white : Colors.grey),
        Icon(Icons.group,
            size: 30,
            color: vProvider.currentPage == 2 ? Colors.white : Colors.grey)
      ],
      onTap: (index) {
        vProvider.currentPage = index;
      },
    );
  }

  static bottomNavItems(int index, ThemeData theme) {
    if (index == 0) {
      return HomePage(
        theme: theme,
      );
    } else if (index == 1) {
      return const LeaderBoardPage();
    } else if (index == 2) {
      return const DisscussionPage();
    }
  }
}
