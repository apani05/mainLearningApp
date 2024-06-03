import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_color/random_color.dart';

import '../../User/user_profile_screen.dart';
import '../../riverpod/river_pod.dart';

class LeaderCard extends ConsumerStatefulWidget {
  final int index ;
  final String name;
  final int score;
  final String currentUserId ;
  const LeaderCard(this.name, {
    super.key,required this.index,required this.score,required this.currentUserId
  });

  @override
 _LeaderCardState createState() => _LeaderCardState();
}

class _LeaderCardState extends ConsumerState<LeaderCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    RandomColor _randomColor = RandomColor();
    Color _color1 = _randomColor.randomColor();
    Color _color2 = _randomColor.randomColor();
    return Padding(
        padding:  EdgeInsets.only(top: widget.index == 0?18.0:0),
        child: GestureDetector(
          onTap: () async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('name', isEqualTo: widget.name == "You" ? widget.currentUserId : widget.name)
      .get();
  print("name ${widget.name}");
print("querySnapshot ${querySnapshot.docs}");
  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot docSnapshot = querySnapshot.docs.first;
    print("docSnapshot ${docSnapshot.data()}");
    String uid = docSnapshot.id;
    if (docSnapshot.exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(uid: uid, isFromLeaderboard: true),
        ),
      );
    } else {
      print('User not found');
    }
  } else {
    print('User not found');
  }
},
          child: Card(
           // color: theme.lightPurple,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            elevation: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_color1, _color2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text((widget.index+1).toString(),
                        style: theme.themeData.textTheme.headlineSmall),
                    const CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.green,
                      child: CircleAvatar(
                        foregroundColor: Colors.green,
                        backgroundImage: AssetImage('assets/person_logo.png'),
                      ),
                    ),
                    Text(
                      widget.name==""?"username":widget.name,
                      style: theme.themeData.textTheme.headlineSmall,
                    ),
                    Text(
                      widget.score.toString(),
                      style: theme.themeData.textTheme.headlineSmall,
                    )
                  ]
              ),
            ),
          ),
        ));
  }
}

class UserData {
  final String name;
  final String email;
  final int score;

  UserData({required this.name, required this.email, required this.score});

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      name: data['name'],
      email: data['email'],
      score: data['score'],
    );
  }
}