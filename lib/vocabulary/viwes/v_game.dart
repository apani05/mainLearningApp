import 'package:bfootlearn/Home/widgets/crad_option.dart';
import 'package:bfootlearn/common/bottomnav.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:bfootlearn/vocabulary/viwes/practice_page.dart';
import 'package:bfootlearn/vocabulary/viwes/saved_pages.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'flash_card_page.dart';

class VocabularyGame extends ConsumerStatefulWidget {
  final String category;

  final String uid;
   const VocabularyGame({required this.category,required this.uid,super.key});

  @override
  VocabularyViewState createState() => VocabularyViewState();
}

class VocabularyViewState extends ConsumerState<VocabularyGame> {
  @override
  void initState() {
    super.initState();
  }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );
  //TabController tabController = TabController(length: 3, vsync: ScrollableState());
  //TabController tabController = TabController(length: 3, vsync: ScrollableState());
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return DefaultTabController(
  length: 3, // The number of tabs
  child: Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.black,
      ),
      backgroundColor: theme.lightPurple,
      title: Text(widget.category, style: TextStyle(color: Colors.white),),
      bottom: const TabBar(
        tabs: [
          Tab( text: 'Flash Card',),
          Tab( text: 'Practice'),
          Tab( text: 'Saved'),
        ],
        labelStyle: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    ),
    body: TabBarView(
      //controller: tabController,
      children: [
        // The widgets that will be shown when the corresponding tab is selected
        // Replace these with your own widgets
              FlashCradPage(category: widget.category,),
              PracticePage(category: widget.category,uid: widget.uid, ),
              SavedPage(category: widget.category,),
      ],
    ),
  ),
);
  }
}
