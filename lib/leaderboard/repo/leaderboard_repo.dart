import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'lederborad_model.dart';

class LeaderBoardRepo extends ChangeNotifier {
  final databaseReference = FirebaseDatabase.instance.ref();
  final currentUser = FirebaseAuth.instance.currentUser;
  // Future<Iterable<LeaderBoardModel>> getTopHighScores() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;
  //   final userId = currentUser?.uid;
  //
  //   // Retrieve first 20 data from highest to lowest in firebase
  //   final result = await FirebaseDatabase.instance
  //       .ref()
  //       .child('leaderboard')
  //       .orderByChild('score')
  //       .limitToLast(500)
  //       .once();
  //
  //   final leaderboardScores = result.snapshot.children
  //       .map(
  //       (e) => LeaderBoardModel.fromJson(e.value as Map, e.key == userId),
  //   )
  //       .toList();
  //   leaderboardScores.forEach((element) {
  //     print(element.name);
  //     print(element.score);
  //   });
  //   return leaderboardScores.reversed;
  // }

  addToLeaderBoard(String name, int score) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final uid = currentUser.uid;
      await databaseReference.child('leaderboard').child(uid).set({
        'name': name,
        'score': score,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<LeaderBoardModel>> getTopHighScores(String timeRange) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userId = currentUser?.uid;

  // Get the current date and time
  DateTime now = DateTime.now();

  // Calculate the start of the day, one week ago, and one month ago
  DateTime startOfDay = DateTime(now.year, now.month, now.day);
  DateTime oneWeekAgo = now.subtract(Duration(days: 7));
  DateTime oneMonthAgo = DateTime(now.year, now.month - 1, now.day);

  // Determine the start time based on the time range
  DateTime startTime;
  if (timeRange == 'daily') {
    startTime = startOfDay;
  } else if (timeRange == 'weekly') {
    startTime = oneWeekAgo;
  } else if (timeRange == 'monthly') {
    startTime = oneMonthAgo;
  } else {
    // If the timeRange parameter is not 'daily', 'weekly', or 'monthly', get all scores
    startTime = DateTime.fromMillisecondsSinceEpoch(0);
  }

  // Retrieve scores from Firebase that are greater than or equal to the start time
  final result = await FirebaseDatabase.instance
      .ref()
      .child('leaderboard')
      .orderByChild('timestamp')
      .startAt(startTime.millisecondsSinceEpoch)
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

    leaderboardScores.toList().sort((a, b) => b.score.compareTo(a.score));
    return leaderboardScores.reversed.toList();
}

  updateScore(String userId, int newScore) async {
    try {
      print("updating score");
      await databaseReference.child('leaderboard').child(userId).update({
        'score': newScore,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print(e.toString());
    }
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
        'timestamp': DateTime.now().millisecondsSinceEpoch,
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

  getScore(String uid) async {
    final scoreRef = FirebaseDatabase.instance.ref('leaderboard/$uid');
    final userScoreResult = await scoreRef.child('score').once();
    final score = (userScoreResult.snapshot.value as int?) ?? 0;
    return score;
  }
}
