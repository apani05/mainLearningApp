import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

import '../../User/user_model.dart';

class FlashCradPage extends ConsumerStatefulWidget {
  final String category;
  const FlashCradPage({
    required this.category,
    super.key,
  });

  @override
  _FlashCradPageState createState() => _FlashCradPageState();
}

class _FlashCradPageState extends ConsumerState<FlashCradPage> {

  CarouselController buttonCarouselController = CarouselController();
  final player = AudioPlayer();
   late int score ;
  @override
  void initState() {
    final userRepo = ref.read(userProvider);
    score = userRepo.score;
    userRepo.getSavedWords(userRepo.uid);
    getQustions();
    super.initState();
  }

  getQustions() async {
    final vProvider = ref.read(vocaProvider);
    await vProvider.getDataByCategory(widget.category, 'class_c_', 0);
    await vProvider.getDataByCategory2(widget.category, 'class_c_');
  }

int index = 0;
int scoreIndex = 0;
  setDocRefCat(String s){
    switch(s){
      case 'Weather':
        return 'w_';
      case 'Times of the day':
        return 'T_';
      case 'Classroom Commands':
        return 'class_c_';
      case 'Days':
        return 'class_d_';
      case 'Kinship Terms':
        return 'class_e_';
      case 'Plants':
        return 'class_f_';
      case 'Food':
        return 'class_g_';
      case 'Animals':
        return 'class_h_';
      case 'Numbers':
        return 'class_i_';
      default:
        return 'class_a_';
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final leaderboardRepo = ref.watch(leaderboardProvider);
    final userRepo = ref.watch(userProvider);
    return FutureBuilder(
      future: ref.watch(vocaProvider).getDataByCategory2(widget.category, setDocRefCat(widget.category)),
      builder: (context,snapshot) {
       // print("snapshot.data"+"${widget.category}");
        //print(snapshot.data);
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError) {
          return Center(child: Text('Error'));
        }else{
          return Stack(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                          if (index != 0 )index--;
                         // if (scoreIndex != 0 )scoreIndex--;
                        },
                        // child: Icon(Icons.arrow_back_ios,color: Colors.black,),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.lightPurple
                        ), icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
                      ),
                      Container(
                        width: 250,
                        height: 300,
                        //  color: Colors.green,
                        child: CarouselSlider(
                          items: snapshot.data?.map((e) {
                           // print("data is ------ ${e["data"]["english"]}");
                           // print("data is ------ ${e["data"]["blackfoot"]}");
                            return FlipCard(
                            direction: FlipDirection.HORIZONTAL,
                            speed: 500,
                            flipOnTouch: true,
                            back: Card(
                                color: theme.lightPurple,
                                child: Stack(
                                  children: [
                                    ElevatedButton.icon(
                                        onPressed: (){
                                     // DocumentReference<Map<String, dynamic>> soundReference = e["data"]["sound"];
                                      print("audio source is ${e["data"]["sound"]}");
                                     // player.play(e["data"]["sound"]);
                                      print("audio source is ${e["data"]["sound"]}");
                                      playAudio(e["data"]["sound"]);

                                    },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: theme.lightPurple
                                        ),
                                        icon: Icon(Icons.volume_up,color: Colors.black,),
                                        label: Text('')),
                                    Container(
                                        child: Center(child: Text(e["data"]["blackfoot"],style: TextStyle(fontSize: 30),),
                                        )),
                                  ],
                                )),
                            front: Card(
                              color: theme.lightPurple,
                              child: Container(
                                child: Center(
                                  child: Text(e["data"]["english"],style: TextStyle(fontSize: 30),),
                                ),
                              ),
                            ),
                              onFlip: () {

                              if(index == scoreIndex){
                                scoreIndex = index+1;
                                score += 3;
                                userRepo.updateScore(userRepo.uid, score);
                                leaderboardRepo.addToLeaderBoard(userRepo.name, score);
                                print("score is -------------- $score");
                              }},
                          );
                          }).toList(),
                          carouselController: buttonCarouselController,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.55,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            viewportFraction: 1,
                            aspectRatio: 2.0,
                            initialPage: 0,
                            clipBehavior: Clip.hardEdge,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear);
                          scoreIndex = index+1;
                          index++;

                        },
                        // child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.lightPurple
                        ), icon: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 140,
                right: MediaQuery.of(context).size.width * 0.25 ,
                child: ElevatedButton(
                    onPressed: () {
                      leaderboardRepo.getTopHighScores();
                     // leaderboardRepo.saveHighScore("shrek", );
                      userRepo.addWordToUser(userRepo.uid, Data.fromJson(snapshot.data![index]["data"]), );
                    },
                    child: Text('save',style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple
                    )
                ),
              ),
              Positioned(
                bottom: 140,
                left:  MediaQuery.of(context).size.width * 0.25,
                child: ElevatedButton(
                    onPressed: () => buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
                    child: Text('skip',style: TextStyle(color: Colors.black),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple
                    )
                ),
              ),
            ],
          );
        }

      }
    );
  }
  Future<void> playAudio(String Url) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String audioUrl = Url;

    try {
      // Get the download URL for the audio file
      Uri downloadUrl =Uri.parse(await storage.refFromURL(audioUrl).getDownloadURL()) ;

      // Play the audio using the audioplayers package
       await player.play(UrlSource( downloadUrl.toString()));
      print('Playing');
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

}

class Qustion {
  String blackfoot;
  String english;
  Qustion({required this.blackfoot, required this.english});
  factory Qustion.fromFireStore(DocumentSnapshot <Map<String, dynamic>> snapshot,
  SnapshotOptions? options,
  ) {
    final data = snapshot.data() ;
    return Qustion(
      blackfoot: data?['blackfoot'],
      english: data?['english'],
    );
  }
 toFireStore() {
    return {
      'blackfoot': blackfoot,
      'english': english,
    };
  }
}
