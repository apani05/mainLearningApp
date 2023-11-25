import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'quiz_page.dart';

class FeatureItem extends StatelessWidget {
  final String title;

  const FeatureItem(this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Practice') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuizPage()),
          );
        } else {
          // Handle other feature items
        }
      },
      child: Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
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

  const CategoryItem(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
      ),
    );
  }
}

class SentenceHomePage extends StatelessWidget {
  const SentenceHomePage({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Conversation Learning"),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              onPressed: logout,
              icon: Icon(Icons.logout),
            )
          ]),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 120, // Increased height to accommodate images and text
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                FeatureItem('Practice'),
                FeatureItem('Mini Game'),
                FeatureItem('Saved'),
                FeatureItem('Sentence Tips and Tricks'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                CategoryItem('Party Talk', Icons.party_mode),
                CategoryItem('School', Icons.school),
                CategoryItem('Greetings', Icons.gesture),
                // Add more categories as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
