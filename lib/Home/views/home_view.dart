import 'package:bfootlearn/Home/widgets/bootomnavItems.dart';
import 'package:bfootlearn/Home/widgets/crad_option.dart';
import 'package:bfootlearn/Home/widgets/home_page.dart';
import 'package:bfootlearn/User/user_profile_screen.dart';
import 'package:bfootlearn/common/bottomnav.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flippy/flippy.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    final leaderBoardRepo = ref.read(leaderboardProvider);
    final UserProvide = ref.read(userProvider);
    //leaderBoardRepo.addToLeaderBoard(UserProvide.name??"", UserProvide.score);
    //UserProvide.getScore(UserProvide.uid);
    //UserProvide.setScore(UserProvide.score);
    super.initState();
  }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final vProvider = ref.watch(vocaProvider);
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.white,
        title: Row(
          children: [
             GestureDetector(
               onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>UserProfileScreen()));
               },
               child: CircleAvatar(
                backgroundColor: theme.lightPurple,
                radius: 23,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL??"https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png" ),
                ),
            ),
             ),
            Visibility(child: const Text("LeaderBoard"),visible: vProvider.currentPage == 1 ? true : false,),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              }, icon: Icon(Icons.logout,color: Colors.black,)),

             
        ],
      ),
      body: BottomNavItem.bottomNavItems(vProvider.currentPage,theme.themeData),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar:BottomNavItem.bottomBar(ref, theme.themeData)
    );
  }


}




