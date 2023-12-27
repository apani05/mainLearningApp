import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flip_card/flip_card.dart';

class SavedPage extends ConsumerStatefulWidget {
  const SavedPage({
    super.key,
  });

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends ConsumerState<SavedPage> {

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
    return Stack(
      children: [
        Container(
          color: Colors.blueAccent,
          child: ListView.builder(itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(qustion[index].question),
                subtitle: Text(qustion[index].answer),
              ),
            );
          },
            itemCount: qustion.length,
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
