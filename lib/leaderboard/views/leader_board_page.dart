import 'package:bfootlearn/leaderboard/repo/lederborad_model.dart';
import 'package:bfootlearn/leaderboard/widgets/leadercard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';


import '../../common/bottomnav.dart';
import '../../riverpod/river_pod.dart';
import '../widgets/sliverlist.dart';

class LeaderBoardPage extends ConsumerStatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  _LeaderBoardPageState createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends ConsumerState<LeaderBoardPage> {

  //List<Widget> items = List.generate(100, (index) => LeaderCard("sid",index: index, score: 20,));
  late Iterable<LeaderBoardModel> leader ;
  String _selectedTimeRange = 'All-time';
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
    final userProvide = ref.watch(userProvider);
    final currentUser = FirebaseAuth.instance.currentUser;
    final String? currentUserName;
    // Get the current user's name
    if(currentUser?.displayName?.isEmpty ?? false){
       currentUserName =  currentUser?.email;
    }else{
       currentUserName = currentUser?.displayName;
    }


    return  FutureBuilder(
      future: leaderboardRepo.getTopHighScores(_selectedTimeRange),
      builder: (context,snapshot) {

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if(snapshot.hasData){
          List<LeaderBoardModel>? leaderboardData = snapshot.data;
          userProvide.sortAndUpdateRank();
          leaderboardData?.sort((a, b) => b.score.compareTo(a.score));
          SliverListWithTopContainer sliverList = SliverListWithTopContainer(
            items: List.generate(leaderboardData!.length,
                    (index) => LeaderCard(leaderboardData!.elementAt(index).name ,
                      index: index, score: leaderboardData.elementAt(index).score,currentUserId: userProvide.name,)),
            topContainer: topContainer,
          );
          return Scaffold(
            backgroundColor: Colors.white,
            body:Stack(
              children: [
                sliverList,
                // Positioned(
                //   bottom: -40,
                //   left: 0,
                //   child: Container(
                //     height: 300,
                //     width: 450,
                //     child: Lottie.network('https://lottie.host/a59bd46f-ce8c-4fe5-88ea-b13a6fb2fa42/9izka5ILTd.json'),
                //   ),
                // ),
                Positioned(
                  top: 20,
                  right: 10,
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: theme.lightPurple,
                    ),
                    height: 50,
                    width: 100,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        dropdownColor:  theme.lightPurple,
                        style: const TextStyle(color: Colors.white),
                        value: _selectedTimeRange,
                        items: <String>['Daily', 'Weekly', 'Monthly', 'All-time'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTimeRange = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }else{
          return const Center(child: Text("No Data"));
        }

      }
    );
  }

}


