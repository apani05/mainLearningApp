import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'lederborad_model.dart';

class LeaderBoardRepo extends ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.ref();

  Future<Iterable<LeaderBoardModel>> getTopHighScores() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    // Retrieve first 20 data from highest to lowest in firebase
    final result = await FirebaseDatabase.instance
        .ref()
        .child('leaderboard')
        .orderByChild('score')
        .limitToLast(20)
        .once();

    final leaderboardScores = result.snapshot.children
        .map(
        (e) => LeaderBoardModel.fromJson(e.value as Map, e.key == userId),
    )
        .toList();
    leaderboardScores.forEach((element) {
      print(element.name);
      print(element.score);
    });
    return leaderboardScores.reversed;
  }
  Future<void> saveHighScore(String name, int newScore) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final uid = currentUser.uid;
      final userName = getUserName();
      print(userName.$1);

      // Get the previous score
      final scoreRef = FirebaseDatabase.instance.ref('leaderboard/$uid');
      final userScoreResult = await scoreRef.child('score').once();
      final score = (userScoreResult.snapshot.value as int?) ?? 0;

      // Return if it is not the high score
      if (newScore > score) {
        return;
      }

      await scoreRef.set({
        'name': userName.$1,
        'score': newScore,
      });
    } catch (e) {
      // handle error
    }
  }

  (String,String,String)getUserName(){
    final currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser?.email);
      var k =  currentUser?.email?.substring(0, currentUser.email?.indexOf('@'))??"";
      print("user name is $k");


    final userName = currentUser?.displayName;
    final img_url = currentUser?.photoURL;
    final uid = currentUser?.uid;
    return (userName ?? k,img_url ?? '',uid ?? '');
  }
}
