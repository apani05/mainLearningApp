import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Home/views/home_view.dart';
import '../../helper/helper_functions.dart';
import '../../riverpod/river_pod.dart';

class EmailVerifyPage extends ConsumerStatefulWidget {
  const EmailVerifyPage({super.key});

  @override
  _EmailVerifyPageState createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends ConsumerState<EmailVerifyPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    checkCurrentUserEmailVerification();
  }

  Future<void> checkCurrentUserEmailVerification() async {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      displaySnackBarMessageToUser(e.toString(), context);
    }
  }

  Future<void> checkEmailVerified() async {
    FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final mediaQuery = MediaQuery.of(context);

    return isEmailVerified
        ? const HomeView()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Email Verification"),
                backgroundColor: theme.lightPurple,
              ),
              body: Center(
                child: Container(
                  margin: EdgeInsets.all(mediaQuery.size.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'A verification email has been sent to your registered email. Please check your inbox.',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFcccbff),
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      ElevatedButton(
                        onPressed:
                            canResendEmail ? sendVerificationEmail : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.lightPurple,
                        ),
                        child: const Text(
                          'Resend Email',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: mediaQuery.size.height * 0.02),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.lightPurple,
                        ),
                        child: const Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
