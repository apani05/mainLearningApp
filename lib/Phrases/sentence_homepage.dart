import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/Phrases/provider/audioPlayerProvider.dart';
import 'package:bfootlearn/Phrases/saved_phrases.dart';
import 'package:bfootlearn/Quizpages/quiz_page.dart';
import 'package:bfootlearn/Quizpages/quiz_result_list.dart';
import 'package:bfootlearn/Phrases/provider/blogProvider.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    IconData iconData = (title == 'Quiz')
        ? Icons.quiz
        : (title == 'Saved')
            ? Icons.saved_search
            : Icons.newspaper;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFcccbff),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
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

class CategoryItem extends ConsumerWidget {
  final List<String> vocabCategory;
  final String seriesName;
  final IconData icon;
  final String imageUrl;

  const CategoryItem(
      this.vocabCategory, this.seriesName, this.icon, this.imageUrl,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogProviderObj = ref.read(blogProvider);
    bool isVocabPresent = vocabCategory.any((element) => element == seriesName);

    return GestureDetector(
      onTap: () async {
        List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName(seriesName);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LearningPage(
                seriesName: seriesName,
                data: filteredData,
                isVocabPresent: isVocabPresent),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: MediaQuery.of(context).size.width * 0.3,
              width: MediaQuery.of(context).size.width * 0.3,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                seriesName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
  List<Map<String, dynamic>> seriesOptions = [];
  List<CardData> allData = [];
  List<String> vocabCategory = [];
  late Future<String> _imageUrlFuture;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchPhrasesData();
    _imageUrlFuture = getImageUrl(
        'gs://blackfootapplication.appspot.com/images/phrase_image.jpg');
  }

  Future<void> _fetchPhrasesData() async {
    final blogProviderObj = ref.read(blogProvider);
    seriesOptions = await blogProviderObj.getSeriesNamesFromFirestore();
    allData = await blogProviderObj.fetchAllData();
    blogProviderObj.updatePhraseData();
    final vProvider = ref.read(vocaProvider);
    vocabCategory = await vProvider.getAllCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);

    final Size screenSize = MediaQuery.of(context).size;

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
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String>(
                  future: _imageUrlFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      _imageUrl = snapshot.data!;
                      return Image.network(
                        _imageUrl,
                        height: screenSize.height * 0.35,
                        width: screenSize.width,
                        fit: BoxFit.cover,
                      );
                    }
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  child: Text(
                    'Features',
                    style: theme.themeData.textTheme.headline6,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.25,
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
                      FeatureItem(
                        title: 'Quiz Results',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizResultList()),
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
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: seriesOptions.isNotEmpty
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: seriesOptions.map((seriesData) {
                            final imageUrl =
                                getImageUrl(seriesData['iconImage']);
                            return FutureBuilder<String>(
                              future: imageUrl,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final String downloadUrl = snapshot.data!;
                                  return CategoryItem(
                                      vocabCategory,
                                      seriesData['seriesName'],
                                      Icons.category,
                                      downloadUrl);
                                }
                              },
                            );
                          }).toList(),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
