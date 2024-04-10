import 'package:bfootlearn/Phrases/saved_page.dart';
import 'package:bfootlearn/pages/quiz_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/river_pod.dart';
import 'category_learning_page.dart';

class FeatureItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FeatureItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFcccbff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem(this.title, this.icon, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LearningPage(seriesName: title)),
        );
      },
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: DisplaySeriesName(seriesId: title, returnText: true),
        ),
      ),
    );
  }
}

class SentenceHomePage extends ConsumerStatefulWidget {
  const SentenceHomePage({Key? key}) : super(key: key);

  @override
  _SentenceHomePageState createState() => _SentenceHomePageState();
}

class _SentenceHomePageState extends ConsumerState<SentenceHomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    List<String> displayedSeriesNames = [];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text("Phrases Learning"),
          backgroundColor: theme.lightPurple,
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  'Features',
                  style: theme.themeData.textTheme.headline6,
                ),
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    FeatureItem(
                      title: 'Saved',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SavedPage()),
                        );
                      },
                    ),
                    FeatureItem(
                      title: 'Quiz',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const QuizPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Text(
                  'Categories',
                  style: theme.themeData.textTheme.headline6,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _getSeriesNames(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: seriesNames.length,
                      itemBuilder: (context, index) {
                        return CategoryItem(seriesNames[index], Icons.category);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> seriesNames = [];
  Future<List<String>> _getSeriesNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ConversationTypes')
        .orderBy('seriesName')
        .get();

    seriesNames = querySnapshot.docs.map((doc) => doc.id).toList();
    return seriesNames;
  }
}

class DisplaySeriesName extends StatelessWidget {
  final String seriesId;
  final bool returnText;

  const DisplaySeriesName(
      {super.key, required this.seriesId, required this.returnText});

  @override
  Widget build(BuildContext context) {
    CollectionReference conversations =
        FirebaseFirestore.instance.collection('ConversationTypes');

    return FutureBuilder<DocumentSnapshot>(
      future: conversations.doc(seriesId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return returnText
              ? Text('${data['seriesName']}')
              : data['seriesName'];
        }
        return const Text('loading');
      }),
    );
  }
}
