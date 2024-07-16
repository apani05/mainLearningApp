import 'package:bfootlearn/User/user_p_details.dart';
import 'package:bfootlearn/User/widgets/custom_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../Home/views/ack_page.dart';
import '../User/user_provider.dart';
import '../leaderboard/widgets/leadercard.dart';
import '../riverpod/river_pod.dart';
import 'dart:math' as math;

class UserProfileScreen extends ConsumerStatefulWidget {
  final String? uid;
  final bool isFromLeaderboard;
  const UserProfileScreen(  {super.key,this.uid, this.isFromLeaderboard = false}) ;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  String score = "0";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

final feedbackController = TextEditingController();
double progress = 0.5;
double progress2 = 0.2;
String dropDownValue = "All";
  @override
  Widget build(BuildContext context) {
    final UserProvide = ref.read(userProvider);
    final leaderBoardRepo = ref.read(leaderboardProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[400],
        body: FutureBuilder(
          future: UserProvide.getUserProfile(widget.isFromLeaderboard ?widget.uid??"": UserProvide.uid),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
             return  const Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return const Center(
                child: Text("An error occurred"),
              );
            }
            else{
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Container(
                          height: 600,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Container(
                              height: 450,
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xffbdbcfd),
                                    Color(0xff6562df),
                                  ],
                                ),
                              ),
                              child: Column(
                                  children: [
                                     Padding(
                                      padding: EdgeInsets.only(top: 30.0),
                                      child: Text(
                                        widget.isFromLeaderboard ?"User Profile":
                                        "My Profile",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.05,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[300],
                                      radius: 53,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 50,
                                        child: CircleAvatar(
                                          radius: 45,
                                          backgroundImage: NetworkImage(snapshot.data!.imageUrl),
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              snapshot.data!.name??"",
                                              style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                               IconButton(
                                                onPressed: ()async{
                                                  final score = snapshot.data!.score.toString();
                                                  final rank = snapshot.data!.rank.toString();
                                                  final text = 'I just scored $score XP and ranked $rank on I\'poyít. Can you beat me?'
                                                      ' Come join me and let\'s see! https://play.google.com/store/apps/details?id=com.bfootlearn.bfootlearn';
                                                  final result = await Share.share(text);
                                                 // if (result.status == ShareResultStatus.success) {
                                                //    print('score shared');
                                                //  }
                                                },
                                                tooltip: "Share Profile",
                                                icon: const Icon(
                                                  Icons.ios_share_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        UserProvide.email??"",
                                        style:  const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Date joined: ",
                                            style:  TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(DateTime.parse(snapshot.data!.joinedDate)),
                                            style:  const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: IconButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: PopupMenuButton<String>(
                                  color: const Color(0xffbdbcfb).withOpacity(0.9),
                                  icon: const Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                  onSelected: (value) async {
                                    switch (value) {
                                      case 'profile':
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) =>  ProfileScoreFeed(uid: widget.isFromLeaderboard ?widget.uid??"": UserProvide.uid),
                                            ));
                                        break;
                                      case 'ack':
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                              builder: (context) => const Acknowledegement(),
                                            ));
                                        break;
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'profile',
                                      child: Text('Edit Profile',
                                        style:
                                        TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ///////////////////////////////////

                          ],
                        ),
                        Positioned(
                          top:400,
                          left:MediaQuery.of(context).size.width*0.05,
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: 4,
                                itemBuilder: (BuildContext context, int index) => buildContainer(index, setHeader(index), setValues(index, snapshot)),
                                staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 1),
                                mainAxisSpacing: 14.0,
                                crossAxisSpacing: 14.0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top:400,
                          left:MediaQuery.of(context).size.width*0.05,
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width - 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[400],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: 4,
                                itemBuilder: (BuildContext context, int index) => buildContainer(index, setHeader(index), setValues(index, snapshot)),
                                staggeredTileBuilder: (int index) => const StaggeredTile.count(2, 1),
                                mainAxisSpacing: 14.0,
                                crossAxisSpacing: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[400],
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 14.0),
                                  child: Text(
                                    "Feedback",
                                    style: TextStyle(
                                      color: Color(0xff6562df),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  controller: feedbackController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    // hintText: "",
                                    hintStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),

                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30,),
                              ElevatedButton(onPressed: (){
                                UserProvide.createFeedback(
                                  feedback: feedbackController.text,
                                  id: widget.isFromLeaderboard ?widget.uid??"": UserProvide.uid,
                                  name: snapshot.data!.name??"",

                                );
                                feedbackController.clear();
                              },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffbdbcfd),
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text("Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }

          }
        ),
      ),
    );
  }

  setValues(int index, snapshot){
    switch(index){
      case 0:
        return snapshot.data!.score.toString();
      case 1:
        return snapshot.data!.rank.toString();
      case 2:
        return setBadgeValue(snapshot).toString();
      case 3:
        return snapshot.data!.heart.toString();
    }
  }

 int setBadgeValue(snapshot) {
  int count = 0;

  if (snapshot.data!.badge.kinship == true) {
    count++;
  }
  if (snapshot.data!.badge.direction == true) {
    count++;
  }
  if (snapshot.data!.badge.classroom == true) {
    count++;
  }
  if (snapshot.data!.badge.time == true) {
    count++;
  }

  if (snapshot.data!.badge.weather == true) {
    count++;
  }
  return count;
}

  setHeader(int index){
    switch(index){
      case 0:
        return "XP Points";
      case 1:
        return "Leaderboard Rank";
      case 2:
        return "Badges Earned";
      case 3:
        return "Hearts Earned";
    }

  }

  Widget buildContainer(int index, String header, String value) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color:  const Color(0xffbdbcfd)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          header,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10), // Add some spacing between the header and the value
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
  String getNameFromEmail(String email) {
    return email.split('@')[0];
  }
}

