import 'package:bfootlearn/Home/views/ack_page.dart';
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
import '../../login/pages/reset_password.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void handlePopupMenuSelection(String value) {
    switch (value) {
      case 'signOut':
        FirebaseAuth.instance.signOut();
        break;
      case 'changePassword':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PasswordChangePage()),
        );
        break;
    }
  }

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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfileScreen(isFromLeaderboard: false,)));
              },
              child: CircleAvatar(
                backgroundColor: theme.lightPurple,
                radius: 23,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(FirebaseAuth
                          .instance.currentUser!.photoURL ??
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
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
              child: const Text("Discusion Forum",style: TextStyle(color: Colors.white),),
            )),
            visible: vProvider.currentPage == 2 ? true : false,
          ),
        ],
      ),
      actions: [
        // IconButton(onPressed: (){
        //   Navigator.push(context,
        //       MaterialPageRoute(
        //           builder: (context) => Acknowledegement(),
        //       ),
        //   );
        // },
        //   icon: Icon(Icons.info_outlined),
        //   color: Colors.black,  ),
        Visibility(
          visible: true,
          child: PopupMenuButton<String>(
            onSelected: handlePopupMenuSelection,
            color: theme.lightPurple,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'signOut',
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sign Out'),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'changePassword',
                  child: ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('Change Password'),
                  ),
                ),
              ];
            },
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
