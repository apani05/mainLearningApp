import 'package:bfootlearn/components/color_file.dart';
import 'package:flutter/material.dart';

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
            ? Icons.folder_special
            : (title == 'Stories')
                ? Icons.diversity_1_rounded
                : Icons.newspaper;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: purpleLight,
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
