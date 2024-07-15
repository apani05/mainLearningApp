import 'package:bfootlearn/Home/widgets/bootomnavItems.dart';
import 'package:bfootlearn/Home/widgets/crad_option.dart';
import 'package:bfootlearn/User/user_model.dart';
import 'package:bfootlearn/common/bottomnav.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:bfootlearn/vocabulary/widgets/gls_cnt.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

class VocabularyHome extends ConsumerStatefulWidget {
  const VocabularyHome({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<VocabularyHome> {

  //List<String> badgeCategories = [];
  @override
  void initState() {
  final userRepo = ref.read(userProvider);
  ref.read(userProvider).setCatagories();
    super.initState();
  }

//   setCatagories() async {
//   final userProvide = ref.read(userProvider);
//   await userProvide.getBadge(userProvide.uid);
//   CardBadge badge = userProvide.badge; // get the badge instance from somewhere
//
//   badgeCategories.clear(); // Clear the list before adding new categories
//
//   if (badge.kinship) {
//     badgeCategories.add('Kinship Terms');
//   }
//   if (badge.direction) {
//     badgeCategories.add('Directions and Time');
//   }
//   if (badge.classroom) {
//     badgeCategories.add('Classroom Commands');
//   }
//   if (badge.time) {
//     badgeCategories.add('Times of the day');
//   }
//   if (badge.weather) {
//     badgeCategories.add('Weather');
//   }
// }

  FlipperController flipperController = FlipperController(
    dragAxis: DragAxis.horizontal,
  );
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final vProvider = ref.watch(vocaProvider);
    final userRepo = ref.watch(userProvider);
    UserModel user = userRepo.user; // get the user instance from somewhere
    print("badge ${userRepo.badge}");
    // String badgeCategory = user.getBadgeCategory();
    // print("badge category $badgeCategory");

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          backgroundColor: theme.lightPurple,
          // title: const CircleAvatar(
          //   backgroundColor: Colors.green,
          //   radius: 23,
          //   child: CircleAvatar(
          //     radius: 20,
          //     backgroundImage: AssetImage("assets/person_logo.png"),
          //   ),
          // ),
          actions: const [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 23,
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/person_logo.png"),
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final userRepo = ref.watch(userProvider);
            final badgeCategories = userRepo.badgeCategories;
            return FutureBuilder(
              future: vProvider.getAllCategories(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return const Center(child: Text("Error"));
                }else{
                  print("snapshot data ${snapshot.data}");
                  return Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          decoration:  BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            //backgroundBlendMode: BlendMode.darken,
                            color: theme.lightPurple,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width,
                          decoration:  BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                            ),
                            //backgroundBlendMode: BlendMode.darken,
                            color: theme.lightPurple,
                          ),
                          child: Center(child: Text("Pick a Category",
                            style: theme.themeData.textTheme.displayMedium?.copyWith(color: Colors.white),
                          )),
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 0,
                        child: Container(
                          height: MediaQuery.of(context).size.height ,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 5,
                            ),
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: ()async{
                                  Navigator.pushNamed(context, '/vgames',
                                      arguments: {
                                        'category': snapshot.data![index],
                                        'uid': userRepo.uid,
                                      }
                                  );
                                  print("firebase data");
                                  await vProvider.getAllCategories();
                                },
                                child: Stack(
                                  children: [
                                    Card(
                                        color: theme.lightPurple,
                                        elevation: 18,
                                      shadowColor: Colors.indigo,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(snapshot.data![index],
                                              softWrap: true,
                                              style: theme.themeData.textTheme.headlineSmall?.copyWith(color: Colors.white),),
                                          ),
                                        ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 10,
                                      child: Visibility(
                                        visible: badgeCategories.contains(snapshot.data![index]) ,
                                        child: Lottie.asset(
                                          'assets/badge.json',
                                         // controller: lottieController,
                                          height: 35,
                                          width: 35,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            );
          }
        )
       // bottomNavigationBar:  BottomNavItem.bottomBar(ref, theme.themeData),
    );
  }
}
