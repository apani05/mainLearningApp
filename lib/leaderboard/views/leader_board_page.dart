import 'package:bfootlearn/leaderboard/repo/lederborad_model.dart';
import 'package:bfootlearn/leaderboard/widgets/leadercard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../common/bottomnav.dart';
import '../../riverpod/river_pod.dart';
import '../widgets/sliverlist.dart';

class LeaderBoardPage extends ConsumerStatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends ConsumerState<LeaderBoardPage> {

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
  //List<Widget> items = List.generate(100, (index) => LeaderCard(index: index,));
  late Iterable<LeaderBoardModel> leader ;

  @override
  void initState() {
    super.initState();
  }

// Create a container for the top of the list
  Widget topContainer = Container(
    height: 100.0,
    width: double.infinity,
    color: Colors.redAccent,
    child: Card(
      child: Container(
        height: 100.0,
        width: double.infinity,
        child: Text(
          'Title',
          style: TextStyle(
            color: ThemeData.dark().primaryColor,
            fontSize: 24.0,
          ),
        ),
      ),
    ),
  );

// Create a SliverListWithTopContainer widget

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final leaderboardRepo = ref.watch(leaderboardProvider);
    return  FutureBuilder(
      future: leaderboardRepo.getTopHighScores(),
      builder: (context,snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasData){
          SliverListWithTopContainer sliverList = SliverListWithTopContainer(
            items: List.generate(snapshot.data!.length, (index) => LeaderCard(snapshot.data!.elementAt(index).name ,index: index, score: snapshot.data!.elementAt(index).score,)),
            topContainer: topContainer,
          );
          return Scaffold(
            backgroundColor: Colors.white,
            // body:  ListView.builder(
            //   itemBuilder: (BuildContext txt, int index) =>
            //       buildList(txt, index),
            //   itemCount: litems.length,
            // ),
            body:sliverList,
          );
        }else{
          return Center(child: Text("No Data"));
        }

      }
    );
  }

}


