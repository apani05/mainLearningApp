import 'package:bfootlearn/Home/widgets/bootomnavItems.dart';
import 'package:bfootlearn/Home/widgets/crad_option.dart';
import 'package:bfootlearn/common/bottomnav.dart';
import 'package:bfootlearn/riverpod/river_pod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flippy/flippy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class VocabularyHome extends ConsumerStatefulWidget {
  const VocabularyHome({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<VocabularyHome> {
  List<String> category = [];
  @override
  void initState() {

   setCatorgories();
    super.initState();
  }

  setCatorgories() async {
    final vProvider = ref.read(vocaProvider);
    category= await vProvider.getAllCategories();
  }
  // List<String> category = [
  //   'Weather',
  //   'Directions',
  //   'Time',
  //   'Days',
  //   'Kinship Terms',
  //   'Plants',
  //   'Food',
  //   'Animals',
  //   'Numbers',
  // ];


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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: const CircleAvatar(
            backgroundColor: Colors.green,
            radius: 23,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/person_logo.png"),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  theme.toggleTheme();
                },
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                )),
          ],
        ),
        body: FutureBuilder(
          future: vProvider.getAllCategories(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return const Center(child: Text("Error"));
            }else{
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 5,
                ),
                itemCount: snapshot.data?.length,
                itemBuilder: (context,int){
                  return GestureDetector(
                    onTap: ()async{
                      Navigator.pushNamed(context, '/vgames',arguments: snapshot.data![int]);
                      print("firebase data");
                      await vProvider.getAllCategories();
                    },
                    child: Card(
                        color: theme.lightPurple,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(snapshot.data![int],
                              softWrap: true,
                              style: theme.themeData.textTheme.headline3?.copyWith(color: Colors.black),),
                          ),
                        )
                    ),
                  );
                },
              );
            }
          }
        )
       // bottomNavigationBar:  BottomNavItem.bottomBar(ref, theme.themeData),
    );
  }
}


