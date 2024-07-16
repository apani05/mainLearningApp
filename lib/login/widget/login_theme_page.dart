import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'fadein_animation.dart';

class LoginPageTop extends ConsumerStatefulWidget {
  const LoginPageTop({super.key});

  @override
  _LoginPageTopState createState() => _LoginPageTopState();
}

class _LoginPageTopState extends ConsumerState<LoginPageTop> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: purpleLight,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.065),
                const FadeIn(
                  child: Text(
                    "I'poyit",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Chewy',
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                Lottie.asset(
                  'assets/smiley_big.json',
                  width: 100,
                  height: 100,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                    FadeIn(
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Chewy',
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText('Blackfoot Language'),
                            RotateAnimatedText('Learning Mobile App'),
                          ],
                          repeatForever: true,
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
