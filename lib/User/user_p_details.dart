import 'package:bfootlearn/User/widgets/custom_progress.dart';
import 'package:flutter/material.dart';

class ProfileScoreFeed extends StatefulWidget {
  const ProfileScoreFeed({super.key});

  @override
  State<ProfileScoreFeed> createState() => _ProfileScoreFeedState();
}

class _ProfileScoreFeedState extends State<ProfileScoreFeed> {

  double progress = 0.5;
  double progress2 = 0.2;
  String dropDownValue = "All";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: const Text('Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )),
        ),
        backgroundColor: Color(0xffbdbcfd),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(30),
        //   ),
        // )
        actions: [
          SizedBox(width: 50,)
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffbdbcfd),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/person_icon.png'),
              ),
              SizedBox(height: 10,),
              Text('Change Avatar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  SizedBox(height: 10,),
                  Text('Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'Harika',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2
                        )
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('User Name',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'Harika',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Password',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'Harika',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Email',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'haari2727@gmail.com',
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 2
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  ElevatedButton(onPressed: (){},
                      child: Text("Delete Account",
                        style: TextStyle(color: Colors.red,fontSize: 18),),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(400, 50)),
                      side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
                      backgroundColor: MaterialStateProperty.all(Color(0xffbdbcfd)),
                      padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    ),
                  )

                ]
              ),
            ],
          ),
        )
      ),
    );
  }
}
