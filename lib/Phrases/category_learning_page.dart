import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/provider/blogProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/river_pod.dart';
import 'card_slider.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

class LearningPage extends ConsumerStatefulWidget {
  final String seriesName;

  const LearningPage({super.key, required this.seriesName});

  @override
  _LearningPageState createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  late Future<String> seriesNameFuture;
  int? currentPlayingIndex;

  @override
  void initState() {
    super.initState();
    seriesNameFuture = fetchSeriesName(widget.seriesName);
    _fetchDataAndUpdateState();
  }

  Future<void> _fetchDataAndUpdateState() async {
    try {
      List<CardData> data = await fetchDataGroupBySeriesName(seriesNameFuture);
      ref.read(blogProvider).updateCardDataList(data);
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final blogProviderObj = ref.watch(blogProvider);

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
          title: FutureBuilder<String>(
            future: seriesNameFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data ?? 'Series Name');
              }
              return const Text('Loading');
            },
          ),
          backgroundColor: theme.lightPurple,
        ),
        body: blogProviderObj.cardDataList.isNotEmpty
            ? CardSlider(
                cardDataList: blogProviderObj.cardDataList,
                currentPlayingIndex: currentPlayingIndex,
                onSavedButtonPressed: (index) {
                  blogProviderObj.toggleSavedStatus(index);
                },
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
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
