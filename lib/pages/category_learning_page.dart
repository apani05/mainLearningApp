import 'package:flutter/material.dart';
import 'quiz_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LearningPage extends StatefulWidget {
  final String seriesName;

  LearningPage({required this.seriesName});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List<bool> _isAccordionExpanded = [];
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

      // Check if seriesNameSnapshot exists and has data
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
        _isAccordionExpanded = List.filled(data.length, false);
        cardDataList = data;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  bool get isContinueButtonEnabled {
    return _isAccordionExpanded.every((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          backgroundColor: Color(0xFFcccbff),
        ),
        body: cardDataList.isNotEmpty
            ? CardSlider(
                cardDataList: cardDataList,
                isAccordionExpanded: _isAccordionExpanded,
                onAccordionTapped: (index) {
                  setState(() {
                    _isAccordionExpanded[index] = !_isAccordionExpanded[index];
                  });
                },
                isContinueButtonEnabled: isContinueButtonEnabled,
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CardSlider extends StatelessWidget {
  final List<CardData> cardDataList;
  final List<bool> isAccordionExpanded;
  final Function(int) onAccordionTapped;
  final bool isContinueButtonEnabled;

  CardSlider({
    required this.cardDataList,
    required this.isAccordionExpanded,
    required this.onAccordionTapped,
    required this.isContinueButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cardDataList.length,
            itemBuilder: (context, index) {
              return CardWidget(
                englishText: cardDataList[index].englishText,
                blackfootText: cardDataList[index].blackfootText,
                isAccordionExpanded: isAccordionExpanded[index],
                onAccordionTapped: () {
                  onAccordionTapped(index);
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: isContinueButtonEnabled
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizPage()),
                    );
                  }
                : null,
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              ),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled)) {
                    return Color(0xFFcecece); // Disabled color
                  }
                  return Color(0xFFcccbff); // Enabled color
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
  final bool isAccordionExpanded;
  final VoidCallback onAccordionTapped;

  CardWidget({
    required this.englishText,
    required this.blackfootText,
    required this.isAccordionExpanded,
    required this.onAccordionTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFcccbff),
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onAccordionTapped,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      englishText,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    isAccordionExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.white,
                    size: 32.0,
                  ),
                ],
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
            AnimatedCrossFade(
              crossFadeState: isAccordionExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
              firstChild: Container(),
              secondChild: Row(
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
                    onPressed: () {
                      // Add your audio play logic here
                    },
                  ),
                ],
              ),
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
