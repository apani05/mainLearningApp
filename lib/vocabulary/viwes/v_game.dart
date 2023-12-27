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
  const VocabularyGame({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<VocabularyGame> {
  @override
  void initState() {
    super.initState();
  }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return Scaffold(
        backgroundColor:  Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          backgroundColor:Colors.white,
          title: const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 23,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  theme.toggleTheme();
                },
                icon: Icon(
                  Icons.menu,
                  color:Colors.black,
                )),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              ButtonsTabBar(
                physics: const ScrollPhysics(),
                // Customize the appearance and behavior of the tab bar
               // backgroundColor: Colors.white,
                height: 60,
                borderColor: Colors.black,
              //  unselectedBackgroundColor: Colors.blueAccent,
                labelStyle: TextStyle(color: Colors.black),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: theme.lightPurple,
                ),
                unselectedDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white),
                unselectedLabelStyle: TextStyle(color: Colors.white),
                // Add your tabs here
                tabs: [
                  Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width/3.5,
                        child: Center(
                          child: Text("Flash Card",style: TextStyle(color: Colors.black),),
                        ),
                      )
                  ),
                  Tab(
                   // text: "practice",
                    child: Container(
                      width: MediaQuery.of(context).size.width/3.5,
                      child: Center(
                        child: Text("Practice",
                            style: TextStyle(color: Colors.black)),
                      ),
                    )
                  ),
                  Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width/3.5,
                        child: Center(
                          child: Text("Saved",style: TextStyle(color: Colors.black)),
                        ),
                      )
                  ),
                ]
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FlashCradPage(),
                   PracticePage(),
                   SavedPage(),
                  ]
                ),
              ),
            ],
          ),
        ),
    );
  }
}




