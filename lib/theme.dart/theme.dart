import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();

  ThemeData get themeData => _themeData;
  bool get isDark => _themeData.brightness == Brightness.dark;


   late AnimationController _controller ;
  late Animation<double> _animation;

  AnimationController get controller => _controller;
  Animation<double> get animation => _animation;

  set controller(AnimationController controller) {
    _controller = controller;
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }
  set animation(Animation<double> animation) {
    _animation = animation;
  }


  Color lightPurple = const Color(0xffbdbcfd);
  Color darkPurple = const Color(0xff6562df);

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    hintColor: Colors.white,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      elevation: 0,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: const CardTheme(
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );


  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    hintColor: Colors.black,
    scaffoldBackgroundColor: Colors.white24,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 50
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textTheme: const TextTheme(
      headline1: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      headline2: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      headline3: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      headline4: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      headline5: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      bodyText1: TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
  );

  void toggleTheme() {
   // _themeData = darkTheme;
    isDark ? _themeData = lightTheme : _themeData = darkTheme;
    notifyListeners();
  }

  void getTheme() {
    _themeData = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }
}