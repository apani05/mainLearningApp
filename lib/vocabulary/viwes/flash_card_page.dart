import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

class FlashCradPage extends ConsumerStatefulWidget {
  const FlashCradPage({
    super.key,
  });

  @override
  _FlashCradPageState createState() => _FlashCradPageState();
}

class _FlashCradPageState extends ConsumerState<FlashCradPage> {

  CarouselController buttonCarouselController = CarouselController();

  List<Qustion> qustion = [
    Qustion(question: '1+1', answer: '2'),
    Qustion(question: '1+2', answer: '3'),
    Qustion(question: '1+3', answer: '4'),
    Qustion(question: '1+4', answer: '5'),
    Qustion(question: '1+5', answer: '6'),
    Qustion(question: '1+6', answer: '7'),
    Qustion(question: '1+7', answer: '8'),
    Qustion(question: '1+8', answer: '9'),
    Qustion(question: '1+9', answer: '10'),
    Qustion(question: '1+10', answer: '11'),
    Qustion(question: '1+11', answer: '12'),
    Qustion(question: '1+12', answer: '13'),
    Qustion(question: '1+13', answer: '14'),
    Qustion(question: '1+14', answer: '15'),
    Qustion(question: '1+15', answer: '16'),
    Qustion(question: '1+16', answer: '17'),
    Qustion(question: '1+17', answer: '18'),
    Qustion(question: '1+18', answer: '19'),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final leaderboardRepo = ref.watch(leaderboardProvider);
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
                    onPressed: () => buttonCarouselController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
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
                    items: qustion.map((e) => FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      speed: 500,
                      flipOnTouch: true,
                      front: Card(
                        color: theme.lightPurple,
                          child: Container(
                              child: Center(child: Text(e.question)))),
                      back: Card(
                        color: theme.lightPurple,
                        child: Container(
                          child: Center(
                            child: Text(e.answer),
                          ),
                        ),
                      ),
                    )).toList(),
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.55,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      aspectRatio: 2.0,
                      initialPage: 2,
                      clipBehavior: Clip.hardEdge,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => buttonCarouselController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.linear),
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
                  leaderboardRepo.saveHighScore("shrek", 20);
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

class Qustion {
  String question;
  String answer;
  Qustion({required this.question, required this.answer});
}
