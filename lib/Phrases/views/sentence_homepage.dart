import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
import 'package:bfootlearn/Phrases/views/saved_phrases.dart';
import 'package:bfootlearn/Quizpages/quiz_page.dart';
import 'package:bfootlearn/Quizpages/quiz_result_list.dart';
import '../../riverpod/river_pod.dart';
import '../widgets/category_item.dart';
import '../widgets/feature_item.dart';

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
    final vProvider = ref.read(vocaProvider);
    seriesOptions = await blogProviderObj.getSeriesNamesFromFirestore();
    allData = await blogProviderObj.fetchAllData();
    blogProviderObj.updateSavedPhrases();
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
                        title: 'Quiz Performance',
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
