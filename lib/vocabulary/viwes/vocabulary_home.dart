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
import 'package:bfootlearn/components/custom_appbar.dart';

class VocabularyHome extends ConsumerStatefulWidget {
  const VocabularyHome({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<VocabularyHome> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final vProvider = ref.watch(vocaProvider);
    final userRepo = ref.watch(userProvider);
    UserModel user = userRepo.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context: context, title: 'Vocabulary Learning'),
      body: Consumer(
        builder: (context, ref, child) {
          final badgeCategories = userRepo.badgeCategories;
          return FutureBuilder(
            future: vProvider.getAllCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error"));
              } else {
                return SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/VocabularyLearning_Image.png',
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                          child: Text(
                            'Pick a Category',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFcccbff),
                              fontFamily: 'Chewy',
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                            childAspectRatio: 2,
                          ),
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, '/vgames',
                                    arguments: {
                                      'category': snapshot.data![index],
                                      'uid': userRepo.uid,
                                    });
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
                                        child: Text(
                                          snapshot.data![index],
                                          softWrap: true,
                                          style: theme.themeData.textTheme.headlineSmall?.copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 10,
                                    child: Visibility(
                                      visible: badgeCategories.contains(snapshot.data![index]),
                                      child: Lottie.asset(
                                        'assets/badge.json',
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
                        Padding(
                          padding: EdgeInsets.only(top: 35, bottom: 16), 
                          child: Text(
                            '"Every word we learn is a step closer to our heritage and our ancestors."',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 198, 175, 241),
                              fontFamily: 'Chewy',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
