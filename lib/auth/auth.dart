import 'package:bfootlearn/Home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/login_or_register.dart';
import '../pages/sentence_homepage.dart';
import '../riverpod/river_pod.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final UserProvide = ref.read(userProvider);
             // final leaderBoardRepo = ref.read(leaderboardProvider);
             // return const SentenceHomePage();
              print("building auth page");
               UserProvide.getUserFromDb(snapshot.data!.uid);
               print("score is ${UserProvide.score}");

              return const HomeView();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
