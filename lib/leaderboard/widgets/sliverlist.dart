import 'package:flutter/material.dart';

import 'leaderbar.dart';

class SliverListWithTopContainer extends StatelessWidget {
  final List<Widget> items;
  final Widget topContainer;

  const SliverListWithTopContainer({
    Key? key,
    required this.items,
    required this.topContainer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(

      slivers: [
        SliverAppBar(
          backgroundColor: Colors.black,
          expandedHeight: 300.0,
          floating: false,
         leading: IconButton(
           onPressed: (){
              Navigator.pop(context);
           },
           icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
         ),
         title: Text("Leaderboard",style: TextStyle(color: Colors.white),),
         //snap: true,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              background: Container(
                child: SizedBox.expand(
                  // child: Image.asset(
                  //   'assets/podium.png',
                  //   fit: BoxFit.cover,
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:  [
                      LeaderBar(barHeight: 120,barWidth: 90,color: Colors.pink,index: 0, image: 'assets/medal.png',),
                     LeaderBar(barHeight: 150,barWidth: 90,color: Colors.green,index: 1, image: 'assets/1st-place.png',),
                      LeaderBar(barHeight: 90,barWidth: 90,color: Colors.deepPurpleAccent,index: 2, image: 'assets/3rd-place.png',),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //   colors: [Colors.purple, Colors.deepPurple],
                  // ),
                  color: Colors.black,
                ),
              )
          ),
        ),

        // List
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return items[index];
            },
            childCount: items.length,
          ),
        ),
      ],
    );
  }
}




