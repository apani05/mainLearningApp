import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';
import 'leaderbar.dart';

class SliverListWithTopContainer extends ConsumerStatefulWidget {
  final List<Widget> items;
  final Widget topContainer;

  const SliverListWithTopContainer({
    Key? key,
    required this.items,
    required this.topContainer,
  }) : super(key: key);

  @override
  _SliverListWithTopContainerState createState() =>
      _SliverListWithTopContainerState();
}

class _SliverListWithTopContainerState extends ConsumerState<SliverListWithTopContainer> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: CustomScrollView(

        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 300.0,
            floating: false,
           // leading: IconButton(
           //   onPressed: (){
           //      Navigator.pop(context);
           //   },
           //   icon: Icon(Icons.arrow_back_ios,color: theme.themeData.hintColor,),
           // ),
          // title: Text("Leaderboard",style: theme.themeData.textTheme.headline3,),
           //snap: true,
          //  pinned: true,
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
                        LeaderBar(barHeight: 120,barWidth: 90,color: Color(0xFFFFDFBA),index: 0, image: 'assets/medal.png', leaderImages: 'assets/person_logo.png',),
                       LeaderBar(barHeight: 150,barWidth: 90,color: Color(0xFFC1E1DC),index: 1, image: 'assets/1st-place.png', leaderImages: 'assets/person_logo_2.png'),
                        LeaderBar(barHeight: 90,barWidth: 90,color:Color(0xFFEFD6DA),index: 2, image: 'assets/3rd-place.png', leaderImages: 'assets/th_1.jpg',),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   colors: [Colors.purple, Colors.deepPurple],
                    // ),
                    color: Colors.white,
                  ),
                )
            ),
          ),

          // List
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return widget.items[index];
              },
              childCount: widget.items.length,
            ),
          ),
        ],
      ),
    );
  }
}




