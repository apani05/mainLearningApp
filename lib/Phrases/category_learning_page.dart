import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bfootlearn/pages/quiz_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../riverpod/river_pod.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;

  LearningPage({required this.seriesName});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  late List<CardData> cardDataList = [];
  late Future<String> seriesNameFuture;
  int? currentPlayingIndex;

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
          blackfootAudio: docData['blackfootAudio'],
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
                currentPlayingIndex: currentPlayingIndex,
                onPlayButtonPressed: (index) {
                  setState(() {
                    if (currentPlayingIndex == index) {
                      // Stop if the same button is pressed again
                      currentPlayingIndex = null;
                    } else {
                      // Play the clicked audio
                      currentPlayingIndex = index;
                    }
                  });
                },
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class CardSlider extends StatelessWidget {
  final List<CardData> cardDataList;
  final int? currentPlayingIndex;
  final Function(int) onPlayButtonPressed;

  CardSlider({
    required this.cardDataList,
    required this.currentPlayingIndex,
    required this.onPlayButtonPressed,
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
                blackfootAudio: cardDataList[index].blackfootAudio,
                isPlaying: currentPlayingIndex == index,
                onPlayButtonPressed: () {
                  onPlayButtonPressed(index);
                },
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

class CardWidget extends ConsumerWidget {
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  final bool isPlaying;
  final VoidCallback onPlayButtonPressed;

  CardWidget({
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.isPlaying,
    required this.onPlayButtonPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(audioPlayerProvider);
    final theme = ref.watch(themeProvider);

    return Card(
      color: theme.lightPurple,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                SizedBox(width: 20),
                Icon(Icons.favorite, color: Colors.white), // Heart icon
              ],
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
                ElevatedButton.icon(
                  onPressed: () {
                    onPlayButtonPressed();
                    playAudio(context, blackfootAudio, player, isPlaying);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPlaying ? theme.red : Colors.white,
                  ),
                  icon: Icon(
                    isPlaying ? Icons.stop : Icons.volume_up,
                    color: isPlaying ? Colors.white : theme.lightPurple,
                  ),
                  label: Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> playAudio(BuildContext context, String audioUrl,
      AudioPlayer player, bool isPlaying) async {
    try {
      Uri downloadUrl = Uri.parse(
          await FirebaseStorage.instance.refFromURL(audioUrl).getDownloadURL());
      await player.stop();
      if (!isPlaying) {
        await player.play(UrlSource(downloadUrl.toString()));
      }
    } catch (e) {
      print('Error in audio player: $e');
    }
  }
}

class CardData {
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;

  CardData({
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
  });
}
