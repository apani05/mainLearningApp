import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../riverpod/river_pod.dart';
import '../views/category_learning_page.dart';

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
