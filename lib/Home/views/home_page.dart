import 'package:bfootlearn/Home/widgets/crad_option.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
             CircleAvatar(
               radius: 23,
               backgroundColor: Colors.white,
               child: CircleAvatar(
                 radius: 20,
                 backgroundImage: AssetImage('assets/person_2.jpg'),
               ),
             ),
              SizedBox(width: 10,),
              Text('Bfootlearn',style: TextStyle(color: Colors.white),),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                //  Navigator.pushNamed(context, SettingsPage.routeName);
              },
              icon: const Icon(Icons.notifications,color: Colors.white,),
            ),
            IconButton(
              onPressed: () {
                //  Navigator.pushNamed(context, SettingsPage.routeName);
              },
              icon: const Icon(Icons.settings,color: Colors.white,),
            ),

          ],
        ),
        body: Stack(children: [
          CradSlider(),
          Positioned(
            bottom: 50,
            right: MediaQuery.of(context).size.width/14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/leaderboard')
                  },

                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(160, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                  )
                ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                     Image(image: AssetImage('assets/podium.png'),height: 20,width: 20,),
                      Text('Leaderboard'),
                    ],
                  ),
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.pushNamed(context, '/discussion')
                  },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(160, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )
                    ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Image(image: AssetImage('assets/meeting.png'),height: 20,width: 20,),
                      Text('Disscussion'),
                    ],
                  ),
                ),
              ],

            ),
          )
        ],
        ),
      ),
    );
  }
}

class CradSlider extends StatefulWidget {
  @override
  State<CradSlider> createState() => _CradSliderState();
}

class _CradSliderState extends State<CradSlider> with SingleTickerProviderStateMixin {
  CarouselController carouselController = CarouselController();


  int _current = 0;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: 2,
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                CardOption(option: itemIndex == 0 ?"Vocabulary":"Sentence",),
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              onPageChanged: (index, reason) {

                setState(() {
                  _current = index;
                });

              },
            ),
          ),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center
              , children: [
            Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.green : Colors.white).withOpacity(_current == 0 ? 0.9 : 0.4)),
            ),
            Container(
              width: 12.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark ? Colors.green : Colors.white).withOpacity(_current == 1 ? 0.9 : 0.4)),
            )
          ]),
          const SizedBox(height: 100,),
          ],
      ),
    );
  }
}

