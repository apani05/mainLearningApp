import 'package:flutter/material.dart';

class LeaderBar extends StatefulWidget {
  final double barHeight ;
  final double barWidth ;
  final Color color;
  final int index;
  final String image;
  const LeaderBar({
    super.key,required this.barHeight ,required this.barWidth, required this.color, required this.index, required this.image,
  });

  @override
  State<LeaderBar> createState() => _LeaderBarState();
}

class _LeaderBarState extends State<LeaderBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: widget.barHeight,
            width: widget.barWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: widget.color,
            ),
            child: Center(child: Column(
              mainAxisAlignment:widget.index == 1?MainAxisAlignment.center: MainAxisAlignment.end,
              children: [
                Text("230",style: TextStyle(color: Colors.white,fontSize: 16),),
                Text("John Doe",style: TextStyle(color: Colors.white,fontSize: 18),),

              ],
            )),
          ),
          Positioned(
            top: -20,
            left: 15,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.yellow,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/prson_1.jpg'),
                ),
              ),
            ),
          ),
          Positioned(
              top: -70,
              left: 15,
              child:Image.asset(widget.image,height: 60,width: 60,)),

        ]
    );
  }
}