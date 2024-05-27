import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Language Learning Blog'),
          backgroundColor: Color(0xFFcccbff),
        ),
        body: BlogCardSlider(),
      ),
    );
  }
}

class BlogCardSlider extends StatefulWidget {
  @override
  _BlogCardSliderState createState() => _BlogCardSliderState();
}

class _BlogCardSliderState extends State<BlogCardSlider> {
  List<BlogPostData> blogPosts = [
    BlogPostData(
      "English sentence 1",
      "Ikosi kiiyi miiksistookatsi 1",
      "Category 1",
    ),
    BlogPostData(
      "English sentence 2",
      "Ikosi kiiyi miiksistookatsi 2",
      "Category 2",
    ),
    BlogPostData(
      "English sentence 3",
      "Ikosi kiiyi miiksistookatsi 3",
      "Category 1",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: blogPosts.length,
            itemBuilder: (context, index) {
              return BlogPostCard(
                englishText: blogPosts[index].englishText,
                blackfootText: blogPosts[index].blackfootText,
                category: blogPosts[index].category,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogPostDetailPage(
                        englishText: blogPosts[index].englishText,
                        blackfootText: blogPosts[index].blackfootText,
                        category: blogPosts[index].category,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class BlogPostData {
  final String englishText;
  final String blackfootText;
  final String category;

  BlogPostData(this.englishText, this.blackfootText, this.category);
}

class BlogPostCard extends StatelessWidget {
  final String englishText;
  final String blackfootText;
  final String category;
  final VoidCallback onTap;

  BlogPostCard({
    required this.englishText,
    required this.blackfootText,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFcccbff),
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                englishText,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
                height: 16,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(height: 8.0),
              Text(
                blackfootText,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Category: $category',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogPostDetailPage extends StatelessWidget {
  final String englishText;
  final String blackfootText;
  final String category;

  BlogPostDetailPage({
    required this.englishText,
    required this.blackfootText,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Post Detail'),
        backgroundColor: Color(0xFFcccbff),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'English Text:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              englishText,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Blackfoot Text:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              blackfootText,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Category:',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFcccbff),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              category,
              style: TextStyle(
                fontSize: 18.0,
                color: Color(0xFFcccbff),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
