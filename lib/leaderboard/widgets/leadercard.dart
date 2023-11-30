import 'package:flutter/material.dart';

class LeaderCard extends StatelessWidget {
  final int index ;
  const LeaderCard({
    super.key,required this.index
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:  EdgeInsets.only(top: index == 0?18.0:0),
        child: Card(
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            height: 60,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text((index+4).toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  CircleAvatar(
                    foregroundColor: Colors.green,
                    backgroundImage: AssetImage('assets/person_2.jpg'),
                  ),
                  Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Score",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )
                ]
            ),
          ),
        ));
  }
}