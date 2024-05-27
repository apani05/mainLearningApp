import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:bfootlearn/vocabulary/provider/voca_provider.dart';
import 'package:bfootlearn/vocabulary/viwes/practice_page.dart';
import 'package:bfootlearn/vocabulary/viwes/vocabulary_home.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';
import 'package:lottie/lottie.dart';

import '../../Phrases/category_learning_page.dart';
import '../../User/user_model.dart';

class FlashCradPage extends ConsumerStatefulWidget {
   String category;
   //final TabController tabController ;
   FlashCradPage(
      // this.tabController,
       {
    required this.category,
    super.key,
  });

  @override
  _FlashCradPageState createState() => _FlashCradPageState();
}

class _FlashCradPageState extends ConsumerState<FlashCradPage> with TickerProviderStateMixin{

  CarouselController buttonCarouselController = CarouselController();
  final player = AudioPlayer();
   late int score ;
   var lottieController;
   var progress2 = 0.0;
   CardBadge newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: false);

  late ConfettiController _controllerCenter;
  @override
  void initState() {
    final userRepo = ref.read(userProvider);
    final vocaProvide = ref.read(vocaProvider);
    //vocaProvide.titleId = widget.category;
    score = userRepo.score;
    userRepo.getSavedWords(userRepo.uid);
    print("init state categoy is ${widget.category}");
    //getQustions();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
     lottieController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

@override
  dispose() {
    _controllerCenter.dispose();
    lottieController.dispose();
    super.dispose();
  }
  setNewBadge(String category){
    switch(category){
      case 'Weather':
        setState(() {
          newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: true);
        });
        break;
      case 'Times of the day':
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: true);
        break;
      case 'Classroom Commands':
        setState(() {
          newBadge = CardBadge(kinship: false, dirrection: false, classroom: true, time: false);
        });
        break;
      case 'Days':
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: true, time: false);
        break;
      case 'Kinship Terms':
        newBadge = CardBadge(kinship: true, dirrection: false, classroom: false, time: false);
        break;
      case 'Directions and Time':
        newBadge = CardBadge(kinship: false, dirrection: true, classroom: false, time: true);
        break;
      case 'Food':
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: true);
        break;
      case 'Animals':
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: true);
        break;
      case 'Numbers':
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: true);
        break;
      default:
        newBadge = CardBadge(kinship: false, dirrection: false, classroom: false, time: false);
    }
  }
  // getQustions() async {
  //   final vProvider = ref.read(vocaProvider);
  //   await vProvider.getDataByCategory(widget.category, 'class_c_', 0);
  //   await vProvider.getDataByCategory2(widget.category, 'class_c_');
  // }
ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
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
      case 'Directions and Time':
        return 'directions_time_';
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
    final vocaProvide = ref.read(vocaProvider);
    print("build state categoy is ${widget.category}");
    return FutureBuilder(
      future: vocaProvide.getDataByCategory2(widget.category, setDocRefCat(widget.category)),
      builder: (context,snapshot) {
       // print("snapshot.data"+"${widget.category}");
        //print(snapshot.data);
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError
        //){
            ||
            snapshot.data!.where((element) =>
            element["data"] == null ||
                (element["data"] != null && (element["data"]["blackfoot"] == null ||
                    element["data"]["english"] == null || element["data"]["sound"] == null))).length > 0 || snapshot.data!.isEmpty) {
          print("snapshot.data""${widget.category} + ${snapshot.data}");
          return Center(child: Text('Error'));
        }else{
        //  print("snapshot.data""${widget.category} + ${snapshot.data}");
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
                                        child: Center(child: Column(
                                          children: [
                                            Text(e["data"]["blackfoot"],style: TextStyle(fontSize: 30),),
                                            Lottie.network(
                                              e["data"]["Lottie"]??"https://lottie.host/018122ea-52fb-474a-9e47-897379e8e629/foSzXLAMUp.json",
                                              renderCache: RenderCache.drawingCommands,
                                            )
                                          ],
                                        ),
                                        )),
                                  ],
                                )),
                            front: Card(
                              color: theme.lightPurple,
                              child: Container(
                                child: Center(
                                  child: Text(e["data"]["english"],style: TextStyle(fontSize: 30),),
                                )
                              ),
                            ),
                              onFlip: () {

                              if(index == scoreIndex){
                                scoreIndex = index+1;
                                score += 3;
                                userRepo.updateScore(userRepo.uid, score);
                                leaderboardRepo.addToLeaderBoard(userRepo.user.name, score);
                                print("score is -------------- $score");
                                double progress = (scoreIndex / snapshot.data!.length) ; // replace totalNumberOfCards with the actual number of cards
                                print("progress is -------------- $progress");
                                 isPlaying.value = true;
                                 vocaProvide.lProgress = progress;
                                 if(progress <= 0.8) {
                                   lottieController.animateTo(progress);
                                 }else if(progress > 0.8){
                                   lottieController.animateTo(1.toDouble());
                                 }
                                progressNotifier.value = progress;
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
                            enableInfiniteScroll: false,
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
                      userRepo.addWordToUser(userRepo.uid, SavedWords.fromJson(snapshot.data![index]["data"]), );
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
              Positioned(
                bottom: 50,
                right: MediaQuery.of(context).size.width * 0.25 ,
                child: ElevatedButton(
                    onPressed: () {
                      if(widget.category == 'Directions and Time') {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LearningPage(seriesName: 'Dvc1tl9L0UYgik1X5zOT')),
                      );
                      }else if(widget.category == 'Weather'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'Ge8eXFpeuoMOpt4OJM4l')),
                        );
                        }else if(widget.category == 'Kinship Terms'){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'h3QH0rikK63QTZ7Lr8wP')),
                        );
                      }else if(widget.category == 'Classroom Commands') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'ueEFv1EI9xm9ciT8u2vt')),
                        );
                      }else if(widget.category == 'Time of the day') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'VJsM4pkVy0h9y74To9PG')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple
                    ),
                    child: Text('Explore related phrases?',style: TextStyle(color: Colors.black),)
                ),
              ),
              Positioned(
                  top: 20,
                  left: 30,
                  child: Row(
                    children: [
                      SizedBox(
                          height: 30,
                          width: 300,
                          child: ValueListenableBuilder<double>(
                            valueListenable: progressNotifier,
                            builder: (context, value, child) {
                              if(value>=1){
                                Future.delayed(const Duration(seconds: 30), () {
                                  _controllerCenter.play();
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    _showMyDialog(DefaultTabController.of(context));
                                  });
                                });

                              }
                              return LinearProgressIndicator(
                                color: theme.lightPurple,
                                minHeight: 30,
                                borderRadius: BorderRadius.circular(20),
                                value: value,
                              );
                            },
                          )
                      ),
                      SizedBox(
                          height: 70,
                          width: 70,
                          child:
                          ValueListenableBuilder(
                              valueListenable: isPlaying,
                              builder: (context, value, child) {
                                if(value == true) {
                                  return Lottie.asset(
                                    'assets/heart.json',
                                    controller: lottieController,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.fill,
                                  );
                                }else{
                                  return Icon(Icons.favorite_border,color: Colors.orangeAccent,size: 40,);
                                }
                              }
                          )
                      ),
                    ],
                  )
              ),
              
              Positioned(
                top: 0,
                left: MediaQuery.of(context).size.width * 0.5,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                 // blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                  shouldLoop: true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  blastDirection: pi / 2,
                  numberOfParticles: 40,// apply the direction
                  //createParticlePath: drawStar, // define a custom shape/path.
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
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  void _showMyDialog(TabController tabController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            AlertDialog(
              title: const Text('Congratulations'),
              content: Text('You have completed the category and earned a badge. Your score is $score.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Choose a new category'),
                  onPressed: () async{
                    setNewBadge(widget.category);
                    await ref.read(userProvider).updateBadge(ref.read(userProvider).uid, newBadge);
                    _controllerCenter.stop();
                    progressNotifier.value = 0.0;
                    if(mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => VocabularyHome()));
                    }

                  },
                ),
                TextButton(
                  child: const Text('Master Again'),
                  onPressed: () {
                    _controllerCenter.stop();
                    scoreIndex = 0;
                    index = 0;
                    buttonCarouselController.jumpToPage(0);
                    Navigator.of(context).pop();
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return TextButton(
                      child: const Text('Practice'),
                      onPressed: () {
                        if(mounted) {
                         tabController.animateTo(1);
                        }
                        Navigator.of(context).pop();
                      },
                    );
                  }
                ),
              ],
            ),
            Positioned(
              top: 270, // Adjust this value as needed
              right: 60, // Adjust this value as needed
              child: Lottie.asset('assets/badge.json', width: 50, height: 50),
            ),

          ],
        );
      },
    );
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
