import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../User/user_provider.dart';
import '../riverpod/river_pod.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
String score = "0";
  @override
  void initState() {
    final UserProvide = ref.read(userProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvide = ref.read(userProvider);
    final leaderBoardRepo = ref.read(leaderboardProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: UserProvide.getUserFromDb(UserProvide.uid),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
             return  Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffbdbcfd),
                            Color(0xff6562df),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 0,
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
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.16,
                    left: MediaQuery.of(context).size.width / 2 - 90,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      radius: 93,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 90,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: Image.asset("assets/person_logo.png").image,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.4,
                    left: MediaQuery.of(context).size.width * 0.15,
                    child: Container(
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          getNameFromEmail(snapshot.data!.name),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff6562df),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.48,
                    left: MediaQuery.of(context).size.width * 0.15,
                    child: Container(
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          UserProvide.email??"",
                          style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.62,
                      left: MediaQuery.of(context).size.width * 0.02,
                      child: SizedBox(
                        height: 2,
                        width: 400,
                        child: Divider(
                          color: Color(0xffbdbcfd),
                          thickness: 2,
                          indent: 15,
                          endIndent: 15,
                        ),
                      )
                  ),
                  Positioned(
                      top: MediaQuery.of(context).size.height * 0.62,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: SizedBox(
                        height: 200,
                        width: 2,
                        child: VerticalDivider(
                          color: Color(0xffbdbcfd),
                          thickness: 2,
                          endIndent: 5,
                        ),
                      )
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.7,
                    left: MediaQuery.of(context).size.width * 0.12,
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              snapshot.data!.score.toString(),
                              style:  TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6562df),
                              ),
                            ),
                            Text(
                              "Score",
                              style:  TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.7,
                    right: MediaQuery.of(context).size.width * 0.12,
                    child: Container(
                      height: 80,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              UserProvide.rank.toString(),
                              style:  TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6562df),
                              ),
                            ),
                            Text(
                              "Rank",
                              style:  TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

          }
        ),
      ),
    );
  }

  String getNameFromEmail(String email) {
    return email.split('@')[0];
  }
}