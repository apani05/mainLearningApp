import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';

class vocabularyProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> get bottomNavigationKey => _bottomNavigationKey;
}