import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
import 'package:bfootlearn/Phrases/views/saved_phrases.dart';
import 'package:bfootlearn/Phrases/views/stories_page.dart';
import 'package:bfootlearn/Quizpages/pages/quiz_page.dart';
import 'package:bfootlearn/Quizpages/pages/quiz_result_list.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import '../widgets/category_item.dart';
import '../widgets/feature_item.dart';

class SentenceHomePage extends ConsumerStatefulWidget {
  const SentenceHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SentenceHomePageState();
}

class _SentenceHomePageState extends ConsumerState<SentenceHomePage> {
  List<Map<String, dynamic>> seriesOptions = [];
  List<CardData> allData = [];
  List<String> vocabCategory = [];

  @override
  void initState() {
    super.initState();
    _fetchPhrasesData();
  }

  Future<void> _fetchPhrasesData() async {
    final blogProviderObj = ref.read(blogProvider);
    final vProvider = ref.read(vocaProvider);
    seriesOptions = await blogProviderObj.getSeriesNamesFromFirestore();
    allData = await blogProviderObj.fetchAllData();
    blogProviderObj.getSavedPhrases();
    vocabCategory = await vProvider.getAllCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: customAppBar(context: context, title: 'Phrases Learning'),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/phrase_image.jpg',
                  height: screenSize.height * 0.35,
                  width: screenSize.width,
                  fit: BoxFit.cover,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  child: Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: purpleLight,
                      fontFamily: 'Chewy',
                      letterSpacing: 2,
                    ),
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
                        title: 'Quiz Performance',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizResultList()),
                          );
                        },
                      ),
                      FeatureItem(
                        title: 'Stories',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const StoriesPage()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: purpleLight,
                      fontFamily: 'Chewy',
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,
                  child: seriesOptions.isNotEmpty
                      ? ListView(
                          scrollDirection: Axis.horizontal,
                          children: seriesOptions.map((seriesData) {
                            final imageUrl =
                                getDownloadUrl(seriesData['iconImage']);
                            return FutureBuilder<String>(
                              future: imageUrl,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    snapshot.hasError ||
                                    snapshot.data == null ||
                                    snapshot.data!.isEmpty) {
                                  return CategoryItem(vocabCategory,
                                      seriesData['seriesName'], '');
                                } else {
                                  final String downloadUrl = snapshot.data!;
                                  return CategoryItem(vocabCategory,
                                      seriesData['seriesName'], downloadUrl);
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
