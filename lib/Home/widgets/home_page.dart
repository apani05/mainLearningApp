import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bfootlearn/Phrases/views/sentence_homepage.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<Color> colorizeColors = [
    const Color(0xFFE6E6FA),
    const Color(0xFFFFF0F5),
    const Color(0xFF967BB6),
    const Color(0xFFA76BCF)
  ];
  TextStyle colorizeTextStyle = const TextStyle(
    fontSize: 28.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            color: theme.lightPurple,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Center(
              // child: Text(
              //   'Welcome to I\'poyít ',
              //   style: widget.theme.textTheme.headline1?.copyWith(
              //     color: Colors.white,
              //   ),
              // ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to ',
                    style: widget.theme.textTheme.headline1?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  AnimatedTextKit(animatedTexts: [
                    ColorizeAnimatedText(
                      ' I\'poyít',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/vocabulary');
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: theme.lightPurple,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Center(
                    child: Text(
                      'Vocabulary',
                      style: widget.theme.textTheme.headline1?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SentenceHomePage()));
              },
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: theme.lightPurple,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Center(
                    child: Text(
                      'Phrases',
                      style: widget.theme.textTheme.headline1?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
