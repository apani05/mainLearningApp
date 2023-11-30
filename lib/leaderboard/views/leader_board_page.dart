import 'package:bfootlearn/leaderboard/widgets/leadercard.dart';
import 'package:flutter/material.dart';


import '../widgets/sliverlist.dart';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  List<String> names = [
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4"
  ];
  List<String> litems = [
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4",
    "1",
    "2",
    "3",
    "4"
  ];
  List<Widget> items = List.generate(100, (index) => LeaderCard(index: index,));


// Create a container for the top of the list
  Widget topContainer = Container(
    height: 100.0,
    width: double.infinity,
    color: Colors.blue,
    child: Card(
      child: Container(
        height: 100.0,
        width: double.infinity,
        child: Text(
          'Title',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
          ),
        ),
      ),
    ),
  );

// Create a SliverListWithTopContainer widget

  @override
  Widget build(BuildContext context) {
    SliverListWithTopContainer sliverList = SliverListWithTopContainer(
      items: items,
      topContainer: topContainer,
    );
    return  Scaffold(
      backgroundColor: Colors.black,
      // body:  ListView.builder(
      //   itemBuilder: (BuildContext txt, int index) =>
      //       buildList(txt, index),
      //   itemCount: litems.length,
      // ),
      body:sliverList,
    );
  }

}


