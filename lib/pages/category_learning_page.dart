import 'package:flutter/material.dart';
import 'quiz_page.dart';

class LearningPage extends StatelessWidget {
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
          title: Text('Party Talk'),
          backgroundColor: Color(0xFFcccbff),
        ),
        body: CardSlider(),
      ),
    );
  }
}

class CardSlider extends StatefulWidget {
  @override
  _CardSliderState createState() => _CardSliderState();
}

class _CardSliderState extends State<CardSlider> {
  List<bool> _isAccordionExpanded = [false, false, false];

  List<CardData> cardDataList = [
    CardData("English sentence 1", "Ikosi kiiyi miiksistookatsi 1"),
    CardData("English sentence 2",
        "Ikosi kiiyi miiksistookatsi 2 Ikosi kiiyi miiksistookatsi 2 Ikosi kiiyi miiksistookatsi 2 Ikosi kiiyi miiksistookatsi 2"),
    CardData("English sentence 3", "Ikosi kiiyi miiksistookatsi 3"),
  ];

  bool get isContinueButtonEnabled {
    return _isAccordionExpanded.every((value) => value);
  }

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
                isAccordionExpanded: _isAccordionExpanded[index],
                onAccordionTapped: () {
                  setState(() {
                    _isAccordionExpanded[index] = !_isAccordionExpanded[index];
                  });
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

class CardData {
  final String englishText;
  final String blackfootText;

  CardData(this.englishText, this.blackfootText);
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
              onTap: onAccordionTapped, // Trigger the callback on tap
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
