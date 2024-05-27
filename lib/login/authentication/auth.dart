import 'package:bfootlearn/Home/views/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../riverpod/river_pod.dart';
import 'login_or_register.dart';
import 'verify_email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
               // Update the rank in the database
              UserProvide.getRank(snapshot.data!.uid).then((rank) {
                // Update the rank in the database
                UserProvide.updateRank(snapshot.data!.uid, rank);
              });
              return const EmailVerifyPage();
            } else {
              return const LoginOrRegister();
            }
          }),
    );
  }
}
