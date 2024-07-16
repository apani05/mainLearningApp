import 'dart:math';
import 'dart:developer' as logger;
import 'package:audioplayers/audioplayers.dart';
import 'package:bfootlearn/Phrases/models/card_data.dart';
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
import '../../Phrases/views/category_learning_page.dart';
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

class _FlashCradPageState extends ConsumerState<FlashCradPage>
    with TickerProviderStateMixin {
  CarouselController buttonCarouselController = CarouselController();
  final player = AudioPlayer();
   late int score ;
   var lottieController;
   var progress2 = 0.0;
   int cardsFlipped = 0;
   late CardBadge newBadge;
  Map<String, Map<String, dynamic>> categoryValues = {};

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    final userRepo = ref.read(userProvider);
    final vocaProvide = ref.read(vocaProvider);
    //vocaProvide.titleId = widget.category;
    score = userRepo.score;
    vocaProvide.score = score;
    userRepo.getSavedWords(userRepo.uid, widget.category);
    vocaProvide.storeValuesForCategory(widget.category);
    print("init state categoy is ${widget.category}");
    print("init state score is ${userRepo.score}");
     userRepo.getBadge(userRepo.uid).then((value) {
       newBadge = userRepo.badge;
     });
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
     lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    super.initState();
  }


@override
  dispose() {
    _controllerCenter.dispose();
    lottieController.dispose();
    super.dispose();
  }

  // setNewBadge(String category){
  //   switch(category){
  //     case 'Weather':
  //       setState(() {
  //         newBadge = CardBadge(kinship: false, direction: false, classroom: false, time: true, weather: false);
  //       });
  //       break;
  //     case 'Times of the day':
  //       newBadge = CardBadge(kinship: false, direction: false, classroom: false, time: true, weather: false);
  //       break;
  //     case 'Classroom Commands':
  //       setState(() {
  //         newBadge = CardBadge(kinship: false, direction: false, classroom: true, time: false, weather: false);
  //       });
  //       break;
  //     case 'Kinship Terms':
  //       newBadge = CardBadge(kinship: true, direction: false, classroom: false, time: false, weather: false);
  //       break;
  //     case 'Directions and Time':
  //       newBadge = CardBadge(kinship: false, direction: true, classroom: false, time: true, weather: false);
  //       break;
  //     default:
  //       newBadge = CardBadge(kinship: false, direction: false, classroom: false, time: false, weather: false);
  //   }
  // }

 void setNewBadge(String category){
  switch(category){
    case 'Weather':
      if (!newBadge.weather) {
        newBadge = CardBadge(
          kinship: newBadge.kinship,
          direction: newBadge.direction,
          classroom: newBadge.classroom,
          time: newBadge.time,
          weather: true
        );
      }
      break;
    case 'Times of the day':
      if (!newBadge.time) {
        newBadge = CardBadge(
          kinship: newBadge.kinship,
          direction: newBadge.direction,
          classroom: newBadge.classroom,
          time: true,
          weather: newBadge.weather
        );
      }
      break;
    case 'Classroom Commands':
      if (!newBadge.classroom) {
        newBadge = CardBadge(
          kinship: newBadge.kinship,
          direction: newBadge.direction,
          classroom: true,
          time: newBadge.time,
          weather: newBadge.weather
        );
      }
      break;
    case 'Kinship Terms':
      if (!newBadge.kinship) {
        newBadge = CardBadge(
          kinship: true,
          direction: newBadge.direction,
          classroom: newBadge.classroom,
          time: newBadge.time,
          weather: newBadge.weather
        );
      }
      break;
    case 'Directions and Time':
      if (!newBadge.direction) {
        newBadge = CardBadge(
          kinship: newBadge.kinship,
          direction: true,
          classroom: newBadge.classroom,
          time: newBadge.time,
          weather: newBadge.weather
        );
      }
      break;
    default:
      // If the category doesn't match any of the above, don't change anything
      break;
  }
}

  ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  ValueNotifier<int> lastIndex = ValueNotifier<int>(0);
int index = 0;
int scoreIndex = 0;
double progress = 0.0;
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
        return 'Kinship_';
      case 'Directions and Time':
        return 'directions_time_';
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
    final blogProviderObj = ref.read(blogProvider);
    
    print("build state categoy is ${widget.category}");
    if(widget.category != vocaProvide.category) {
      vocaProvide.resetGame();
      vocaProvide.category = widget.category;
    }
// print("badge is ${newBadge.classroom}");

    Map<String, dynamic> values = vocaProvide.getValuesForCategory(widget.category);
    index = values['index'];
    scoreIndex = values['scoreIndex'];
    score = values['score'];
    progressNotifier.value = values['progress'];
    cardsFlipped = values['cardsFlipped'];
    isPlaying.value = values['isPlaying'];
    lottieController.animateTo(values['lProgress']);
    print("index is $index");
    print("lporgress is ${vocaProvide.lProgress}");
    print("score is $score");
    return FutureBuilder(
      future: vocaProvide.getDataByCategory2(widget.category, setDocRefCat(widget.category)),
      builder: (context,snapshot) {
       // print("snapshot.data"+"${widget.category}");
        //print(snapshot.data);
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError
            ||
            snapshot.data!.where((element) =>
            element["data"] == null ||
                (element["data"] != null && (element["data"]["blackfoot"] == null ||
                    element["data"]["english"] == null || element["data"]["sound"] == null))).length > 0 || snapshot.data!.isEmpty) {
          print("snapshot.data""${widget.category} + ${snapshot.data}");
          return const Center(child: Text('Error'));
        }else{
        //  print("snapshot.data""${widget.category} + ${snapshot.data}");
        //   if(vocaProvide.index != 0){
        //     buttonCarouselController.jumpToPage(vocaProvide.index);
        //   }
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
                          buttonCarouselController.previousPage(
                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                          lastIndex.value = index;
                          if (index != 0 )index--;
                         // if (scoreIndex != 0 )scoreIndex--;

                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.lightPurple
                        ), icon: const Icon(Icons.arrow_back_ios,color: Colors.black,),
                      ),


                      SizedBox(
                        width: 250,
                        height: 300,
                        child: CarouselSlider(
                          items: snapshot.data?.map((e) {
                           print("data is ------ ${e["data"]["english"]}");
                           print("data is ------ ${e["data"]["blackfoot"]}");
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
                                        icon: const Icon(Icons.volume_up,color: Colors.black,),
                                        label: const Text('')),
                                    Container(
                                        child: Center(child: Column(
                                          children: [
                                            Text(e["data"]["blackfoot"],style: const TextStyle(fontSize: 30),),
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
                                  child: Text(e["data"]["english"],style: const TextStyle(fontSize: 30),),
                                )
                              ),
                            ),
                              onFlip: () {

                              if(index == scoreIndex){
                                scoreIndex = index+1;
                                score += 1;
                                userRepo.updateScore(userRepo.uid, score);
                                leaderboardRepo.addToLeaderBoard(userRepo.name, score);
                                vocaProvide.cardsFlipped++;
                                print("score is -------------- $score");
                                double progress = (vocaProvide.cardsFlipped / snapshot.data!.length) ; // replace totalNumberOfCards with the actual number of cards
                                print("progress is -------------- $progress");
                                logger.log('progress is $progress \n score is $score \n index is $index \n scoreIndex is $scoreIndex \n '
                                    'lastIndex is ${lastIndex.value} \n isPlaying is ${isPlaying.value} \n lProgress is ${vocaProvide.lProgress} \n '
                                    'progressNotifier is ${progressNotifier.value} \n',name: "log1");
                                 isPlaying.value = true;
                                 vocaProvide.lProgress = progress;
                                 if(vocaProvide.lProgress <= 0.8) {
                                   lottieController.animateTo(vocaProvide.lProgress);
                                 }else if(vocaProvide.lProgress > 0.8){
                                   lottieController.animateTo(1.toDouble());
                                 }
                                progressNotifier.value = progress;
                                logger.log('progress is $progress \n score is $score \n index is $index \n scoreIndex is $scoreIndex \n '
                                    'lastIndex is ${lastIndex.value} \n isPlaying is ${isPlaying.value} \n lProgress is ${vocaProvide.lProgress} \n '
                                    'progressNotifier is ${progressNotifier.value} \n',name: "log2");
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
                            initialPage: index,
                            clipBehavior: Clip.hardEdge,
                            enableInfiniteScroll: false,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        builder: (context, value, child) {
                          return Offstage(
                            offstage: index == snapshot.data!.length - 1,
                            child: IconButton(
                              onPressed: () {
                                buttonCarouselController.nextPage(
                                    duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                scoreIndex = index+1;
                                index++;
                                lastIndex.value = index;
                                vocaProvide.index = index;

                                },
                              // child: Icon(Icons.arrow_forward_ios,color: Colors.black,),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.lightPurple
                              ), icon: const Icon(Icons.arrow_forward_ios,color: Colors.black,),
                            ),
                          );
                        }, valueListenable:lastIndex,
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
                      userRepo.addWordToUser(userRepo.uid, SavedWords.fromJson(snapshot.data![index]["data"]),widget.category );
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Word saved')));

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple
                    ),
                    child: const Text('save',style: TextStyle(color: Colors.black),)
                ),
              ),
              Positioned(
                bottom: 140,
                left:  MediaQuery.of(context).size.width * 0.25,
                child: ElevatedButton(
                    onPressed: () => buttonCarouselController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.linear),
                    child: const Text('skip',style: TextStyle(color: Colors.black),),
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
                         List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName('Dvc1tl9L0UYgik1X5zOT');
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LearningPage(seriesName: 'Dvc1tl9L0UYgik1X5zOT', data: filteredData,isVocabPresent: false)),
                      );
                      }else if(widget.category == 'Weather'){
                        List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName('Ge8eXFpeuoMOpt4OJM4l');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'Ge8eXFpeuoMOpt4OJM4l', data: filteredData,isVocabPresent: false)),
                        );
                        }else if(widget.category == 'Kinship Terms'){
                          List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName('h3QH0rikK63QTZ7Lr8wP');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'h3QH0rikK63QTZ7Lr8wP', data: filteredData,isVocabPresent: false)),
                        );
                      }else if(widget.category == 'Classroom Commands') {
                        List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName('ueEFv1EI9xm9ciT8u2vt');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'ueEFv1EI9xm9ciT8u2vt', data: filteredData,isVocabPresent: false)),
                        );
                      }else if(widget.category == 'Time of the day') {
                         List<CardData> filteredData =
            blogProviderObj.filterDataBySeriesName('VJsM4pkVy0h9y74To9PG');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LearningPage(seriesName: 'VJsM4pkVy0h9y74To9PG', data: filteredData,isVocabPresent: false)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.lightPurple
                    ),
                    child: const Text('Explore related phrases?',style: TextStyle(color: Colors.black),)
                ),
              ),
              Positioned(
                  top: 20,
                  left: 30,
                  child: Row(
                    children: [
                      SizedBox(
                          height: 30,
                          width: 260,
                          child: ValueListenableBuilder<double>(
                            valueListenable: progressNotifier,
                            builder: (context, value, child) {
                              Future(() {
                                vocaProvide.progress = value;
                              });
                              if(value>=1){
                                userRepo.incrementHeart(userRepo.uid);

                                Future.delayed(const Duration(seconds: 5), () {
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
                                  return const Icon(Icons.favorite_border,color: Colors.orangeAccent,size: 40,);
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
      Uri downloadUrl =
          Uri.parse(await storage.refFromURL(audioUrl).getDownloadURL());

      // Play the audio using the audioplayers package
      await player.play(UrlSource(downloadUrl.toString()));
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
              title: const Text('Great'),
              content: Text(
                  'You have completed the category and earned a ♥. Your XP points are $score.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Choose a new category'),
                  onPressed: () async{
                    final vocaProvide = ref.read(vocaProvider);
                    setNewBadge(widget.category);
                    await ref.read(userProvider).updateBadge(ref.read(userProvider).uid, newBadge);
                    ref.read(userProvider).refreshCatagories();
                    _controllerCenter.stop();
                    progressNotifier.value = 0.0;
                    scoreIndex = 0;
                    index = 0;
                    score = 0;
                    vocaProvide.score = score;
                    vocaProvide.index = index;
                    vocaProvide.progress = 0.0;
                    lastIndex.value = index;
                    vocaProvide.lProgress = 0.0;
                    isPlaying.value = false;
                    progress = 0.0;
                    progressNotifier.value = 0.0;
                    vocaProvide.resetGame();

                    if(mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const VocabularyHome()));
                      Navigator.of(context).pop();

                    }
                  },
                ),
                TextButton(
                  child: const Text('Master Again'),
                  onPressed: () {
                   _resetGame();
                    Navigator.of(context).pop();
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return TextButton(
                      child: const Text('Practice'),
                      onPressed: () {
                      _resetGame();
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
  _resetGame() {
    final vocaProvide = ref.read(vocaProvider);
    _controllerCenter.stop();
    progressNotifier.value = 0.0;
    scoreIndex = 0;
    index = 0;
    score = 0;
    vocaProvide.score = score;
    vocaProvide.index = index;
    vocaProvide.progress = 0.0;
    lastIndex.value = index;
    vocaProvide.lProgress = 0.0;
    isPlaying.value = false;
    progress = 0.0;
    progressNotifier.value = 0.0;
    buttonCarouselController.jumpToPage(0);
    // vocaProvide.setValuesForCategory(widget.category);
    vocaProvide.resetGame();
  }

//   void updateProgressAndAnimation(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
//   final vocaProvide = ref.read(vocaProvider);
//   vocaProvide.cardsFlipped++;
//   double progress = (vocaProvide.cardsFlipped / snapshot.data!.length);
//   isPlaying.value = true;
//   vocaProvide.lProgress = progress;
//   if(vocaProvide.lProgress <= 0.8) {
//     lottieController.animateTo(vocaProvide.lProgress);
//   } else if(vocaProvide.lProgress > 0.8){
//     lottieController.animateTo(1.toDouble());
//   }
//   progressNotifier.value = progress;
// }
}

class Qustion {
  String blackfoot;
  String english;
  Qustion({required this.blackfoot, required this.english});
  factory Qustion.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
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
