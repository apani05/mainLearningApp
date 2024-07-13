import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_color/random_color.dart';

import '../../User/user_profile_screen.dart';
import '../../riverpod/river_pod.dart';

class LeaderCard extends ConsumerStatefulWidget {
  final int index;
  final String name;
  final int score;
  final String currentUserId;
  const LeaderCard(this.name, {super.key, required this.index, required this.score, required this.currentUserId});

  @override
  _LeaderCardState createState() => _LeaderCardState();
}

class _LeaderCardState extends ConsumerState<LeaderCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    RandomColor randomColor = RandomColor();
    Color color1 = randomColor.randomColor();
    Color color2 = randomColor.randomColor();
    return Padding(
      padding: EdgeInsets.only(top: widget.index == 0 ? 18.0 : 0),
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
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          elevation: 0,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [color1, color2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListTile(
              leading: Text((widget.index + 1).toString(), style: theme.themeData.textTheme.headlineSmall),
              title: Row(
                children: [
                  const CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      foregroundColor: Colors.green,
                      backgroundImage: AssetImage('assets/person_logo.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      widget.name == "" ? "username" : widget.name,
                      style: theme.themeData.textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: Text(
                widget.score.toString(),
                style: theme.themeData.textTheme.headlineSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
