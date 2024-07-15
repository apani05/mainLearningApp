import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

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
        controller: PrimaryScrollController.of(context),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                      child: Lottie.network(
                          'https://lottie.host/15e37b33-80de-40e8-8247-d51b4b4c4819/YHXx1MBsrV.json',
                          repeat: false
                        ,),
                  )
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




