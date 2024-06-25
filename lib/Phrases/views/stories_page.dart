import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/provider/mediaProvider.dart';
import 'package:bfootlearn/components/custom_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StoriesPage extends StatefulWidget {
  const StoriesPage({super.key});

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  late Future<String> _imageUrlFuture;
  late Future<List<String>> _audioUrlsFuture;
  String _imageUrl = "";

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = getDownloadUrl(
        'gs://blackfootapplication.appspot.com/images/phrase_image.jpg');
    _audioUrlsFuture = getAudioUrls();
  }

  Future<List<String>> getAudioUrls() async {
    final storageRef = FirebaseStorage.instance.ref().child('story_lessons');
    final ListResult result = await storageRef.listAll();
    final List<String> urls = [];

    for (var item in result.items) {
      final url = await item.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context: context, title: 'Stories'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            children: [
              FutureBuilder<String>(
                future: _imageUrlFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Icon(Icons.image, size: 40));
                  } else if (snapshot.hasError ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Text('Error: Unable to load image');
                  } else {
                    _imageUrl = snapshot.data!;
                    return Image.network(
                      _imageUrl,
                      height: screenSize.height * 0.35,
                      width: screenSize.width,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<String>>(
                future: _audioUrlsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Error: Unable to load audio files');
                  } else {
                    final audioUrls = snapshot.data!;
                    return Expanded(
                      child: ListView.separated(
                        itemCount: audioUrls.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<String>(
                              future: getDownloadUrl(audioUrls[index]),
                              builder: (context, snapshot) {
                                final audioUrl = snapshot.data!;
                                return StoryAudioPlayer(
                                    index: index, audioUrl: audioUrl);
                              });
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 15),
                      ),
                    );
                  }
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
  final int index;
  final String audioUrl;
  const StoryAudioPlayer({
    super.key,
    required this.index,
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Story ${widget.index}',
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
                  size: 30,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
