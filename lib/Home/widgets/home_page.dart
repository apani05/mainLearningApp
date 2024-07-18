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

  TextStyle colorizeTextStyle = TextStyle(
    fontSize: 28.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/HomePageBG.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ColorizeAnimatedText(
                          'Welcome to I\'poyít',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontFamily: 'Horizon',
                          ),
                          colors: colorizeColors,
                        ),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Start your quest',
                    style: widget.theme.textTheme.headlineLarge?.copyWith(
                      color: theme.lightPurple,
                      fontSize: 24.0,
                      fontFamily: 'Chewy',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Card for Vocabulary
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Vocabulary',
                              textAlign: TextAlign.center,
                              style: widget.theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 35),
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Broaden your word bank',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Card for Phrases
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SentenceHomePage(),
                      ),
                    );
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Phrases',
                              textAlign: TextAlign.center,
                              style: widget.theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontSize: 35),
                            ),
                            AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Master everyday phrases',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "Explore and preserve the rich heritage of the Blackfoot culture.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: theme.darkPurple,
        fontSize: 15,
        fontFamily: 'Chewy',
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.white,
            offset: Offset(1, 1),
          ),
        ],
      ),
    ),
  ),
),
Container(
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      "Join us in learning and spreading knowledge about this vibrant tradition.",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: theme.darkPurple,
        fontSize: 15,
        fontFamily: 'Chewy',
        shadows: [
          Shadow(
            blurRadius: 3.0,
            color: Colors.white,
            offset: Offset(1, 1),
          ),
        ],
      ),
    ),
  ),
),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
