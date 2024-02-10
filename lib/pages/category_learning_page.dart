import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../riverpod/river_pod.dart';
import 'package:bfootlearn/pages/quiz_page.dart';

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;

  LearningPage({required this.seriesName});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  late List<CardData> cardDataList = [];
  late Future<String> seriesNameFuture;

  @override
  void initState() {
    super.initState();
    seriesNameFuture = fetchSeriesName();
    fetchData();
  }

  Future<String> fetchSeriesName() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> seriesNameSnapshot =
          await FirebaseFirestore.instance
              .collection('ConversationTypes')
              .doc(widget.seriesName)
              .get();

      if (seriesNameSnapshot.exists) {
        String seriesName = seriesNameSnapshot.data()!['seriesName'];
        return seriesName;
      } else {
        print('Series name not found: ${widget.seriesName}');
        return 'Series Not Found';
      }
    } catch (error) {
      print("Error fetching series name: $error");
      return 'Error Fetching Series Name';
    }
  }

  Future<void> fetchData() async {
    try {
      String seriesName = await seriesNameFuture;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Conversations')
          .where('seriesName', isEqualTo: seriesName)
          .get();

      List<CardData> data = querySnapshot.docs.map((doc) {
        Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
        return CardData(
          englishText: docData['englishText'],
          blackfootText: docData['blackfootText'],
        );
      }).toList();

      setState(() {
        cardDataList = data;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: FutureBuilder<String>(
            future: seriesNameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? 'Series Name');
              }
              return Text('loading');
            },
          ),
          backgroundColor: theme.lightPurple,
        ),
        body: cardDataList.isNotEmpty
            ? CardSlider(
                cardDataList: cardDataList,
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CardSlider extends StatelessWidget {
  final List<CardData> cardDataList;

  CardSlider({
    required this.cardDataList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return CardWidget(
                englishText: cardDataList[index].englishText,
                blackfootText: cardDataList[index].blackfootText,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Color(0xFFcccbff);
                },
              ),
            ),
            child: Text('Continue'),
          ),
        ),
      ],
    );
  }
}

class CardWidget extends StatelessWidget {
  final String englishText;
  final String blackfootText;

  CardWidget({
    required this.englishText,
    required this.blackfootText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFcccbff),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    blackfootText,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardData {
  final String englishText;
  final String blackfootText;

  CardData({required this.englishText, required this.blackfootText});
}
