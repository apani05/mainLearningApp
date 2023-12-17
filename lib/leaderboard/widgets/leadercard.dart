import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';

class LeaderCard extends ConsumerStatefulWidget {
  final int index ;
  final String name;
  final int score;
  const LeaderCard(this.name, {
    super.key,required this.index,required this.score
  });

  @override
 _LeaderCardState createState() => _LeaderCardState();
}

class _LeaderCardState extends ConsumerState<LeaderCard> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Padding(
        padding:  EdgeInsets.only(top: widget.index == 0?18.0:0),
        child: Card(
          color: theme.lightPurple,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text((widget.index+4).toString(),
                      style: theme.themeData.textTheme.headline3),
                  CircleAvatar(
                    radius: 23,
                    backgroundColor: Colors.green,
                    child: CircleAvatar(
                      foregroundColor: Colors.green,
                      backgroundImage: AssetImage('assets/person_logo.png'),
                    ),
                  ),
                  Text(
                    widget.name,
                    style: theme.themeData.textTheme.headline4,
                  ),
                  Text(
                    widget.score.toString(),
                    style: theme.themeData.textTheme.headline3,
                  )
                ]
            ),
          ),
          elevation: 0,
        ));
  }
}