import 'package:bfootlearn/Home/views/ack_page.dart';
import 'package:bfootlearn/Home/widgets/bootomnavItems.dart';
import 'package:bfootlearn/Home/widgets/popup_menu.dart';
import 'package:bfootlearn/User/user_profile_screen.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    final leaderBoardRepo = ref.read(leaderboardProvider);
    final UserProvide = ref.read(userProvider);
    //leaderBoardRepo.addToLeaderBoard(UserProvide.name??"", UserProvide.score);
    //UserProvide.getScore(UserProvide.uid);
    //UserProvide.setScore(UserProvide.score);
  }

  @override
  void dispose() {
    super.dispose();
  }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AppBar buildAppBar(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final vProvider = ref.watch(vocaProvider);
    return AppBar(
      backgroundColor: theme.lightPurple,
      centerTitle: true,
      shape: vProvider.currentPage != 0?RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ):null,
      title: Row(
        children: [
          Visibility(
            visible: true,
            child: GestureDetector(
              onTap: () {
                final userProvide = ref.read(userProvider);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>  UserProfileScreen(isFromLeaderboard: false,uid: userProvide.uid,)));
              },
              child: CircleAvatar(
                backgroundColor: theme.lightPurple,
                radius: 23,
                child: CircleAvatar(
                  radius: 20,
                  // backgroundImage: NetworkImage(FirebaseAuth
                  //         .instance.currentUser!.photoURL ??
                  //     "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  backgroundImage: FirebaseAuth.instance.currentUser!.photoURL != null ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                  as ImageProvider<Object>? : AssetImage('assets/Background2.jpg'),
                ),
              ),
            ),
          ),
          Visibility(
            child: Center(child: Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/4.5),
              child: const Text("Leaderboard",style: TextStyle(color: Colors.white),),
            )),
            visible: vProvider.currentPage == 1 ? true : false,
          ),
          Visibility(
            child: Center(child: Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width/5.5),
              child: const Text("Discussion Forum",style: TextStyle(color: Colors.white),),
            )),
            visible: vProvider.currentPage == 2 ? true : false,
          ),
        ],
      ),
      actions: [
        Visibility(
          visible: true,
          child: CustomPopupMenu(
             onSelected: (value) {},
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: BottomNavItem.bottomNavItems(ref.watch(vocaProvider).currentPage,
          ref.watch(themeProvider).themeData),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      bottomNavigationBar:
          BottomNavItem.bottomBar(ref, ref.watch(themeProvider).themeData),
    );
  }
}
