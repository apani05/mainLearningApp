import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
import 'package:bfootlearn/components/color_file.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, String>>> fetchStories() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('stories')
        .orderBy('topic')
        .get();
    List<Map<String, String>> storiesData = await Future.wait(
      snapshot.docs.map(
        (doc) async => {
          'topic': doc['topic'] as String,
          'link': await getDownloadUrl(doc['link']) as String,
        },
      ),
    );
    return storiesData;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: customAppBar(context: context, title: 'Stories'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'assets/stories_image.png',
                height: screenSize.height * 0.35,
                width: screenSize.width,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Map<String, String>>>(
                future: fetchStories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading stories'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No stories available'));
                  }

                  List<Map<String, String>> storiesData = snapshot.data!;

                  return Expanded(
                    child: ListView.separated(
                      itemCount: storiesData.length,
                      itemBuilder: (context, index) {
                        return StoryAudioPlayer(
                          topic: storiesData[index]['topic']!,
                          audioUrl: storiesData[index]['link']!,
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 15),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryAudioPlayer extends StatefulWidget {
  final String topic;
  final String audioUrl;
  const StoryAudioPlayer({
    super.key,
    required this.topic,
    required this.audioUrl,
  });

  @override
  State<StoryAudioPlayer> createState() => _StoryAudioPlayerState();
}

class _StoryAudioPlayerState extends State<StoryAudioPlayer> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    audioPlayer.setSourceUrl(widget.audioUrl);
  }

  @override
  void initState() {
    super.initState();
    setAudio();

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: purpleLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.topic,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.resume();
                  }
                },
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_outlined
                      : Icons.play_circle_filled_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);

                  await audioPlayer.resume();
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                formatDuration(position),
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                formatDuration(duration - position),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
