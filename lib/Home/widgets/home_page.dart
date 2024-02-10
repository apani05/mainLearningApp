import 'package:bfootlearn/pages/sentence_homepage.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            'Welcome to Blackfoot Learning',
            style: widget.theme.textTheme.headline2?.copyWith(
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/vocabulary');
          },
          child: Card(
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: theme.lightPurple,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text(
                  'Vocabulary',
                  style: widget.theme.textTheme.headline1,
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: theme.lightPurple,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text(
                  'Phrases',
                  style: widget.theme.textTheme.headline1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
