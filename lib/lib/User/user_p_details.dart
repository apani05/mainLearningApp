import 'dart:io';

import 'package:bfootlearn/User/user_firebase_operation.dart';
import 'package:bfootlearn/User/user_provider.dart';
import 'package:bfootlearn/User/widgets/custom_progress.dart';
import 'package:bfootlearn/login/authentication/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../riverpod/river_pod.dart';

class ProfileScoreFeed extends ConsumerStatefulWidget {
  final String uid;
  const ProfileScoreFeed({super.key,required this.uid});

  @override
  _ProfileScoreFeedState createState() => _ProfileScoreFeedState();
}

class _ProfileScoreFeedState extends ConsumerState<ProfileScoreFeed> {

  double progress = 0.5;
  double progress2 = 0.2;
  String dropDownValue = "All";

  final _firestoreOperations = FirestoreOperations();
  late UserProvider _userProvider;
  final ValueNotifier<bool> _isEditing = ValueNotifier(false);
  final ValueNotifier<bool> _isEditPassWord = ValueNotifier(false);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

   File imageFile = File('');
  @override
  void initState() {
    super.initState();
    _userProvider = ref.read(userProvider);
    _nameController.text = _userProvider.name;
    _userNameController.text = _userProvider.username;
    _emailController.text = _userProvider.email;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();

Future<void> pickImage() async {
  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      imageFile = File(pickedFile.path);
    });
    print('Path of picked image: ${imageFile.path}');
  } else {
    print('No image selected.');
  }
}
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
        title: const Center(
          child: Text('Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          )),
        ),
        backgroundColor: const Color(0xffbdbcfd),
        actions:  [
          ValueListenableBuilder(
            valueListenable: _isEditing,
            builder: (context, value, child) {
              return IconButton(onPressed: (){
                if(_isEditing.value){
                  _isEditing.value = false;
                }else{
                  _showBottomSheetForEdit(context);
                }
                },
                  icon:  _isEditing.value?const Icon(Icons.cancel,color: Colors.white,):
                  const Icon(Icons.edit,color: Colors.white,),);
            }
          ),
          const SizedBox(width: 20,)
        ],
      ),
      body: ValueListenableBuilder<bool>(
        builder: (context, value, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xffbdbcfd),
            ),
            child: StreamBuilder<DocumentSnapshot>(
              stream:_firestoreOperations.streamDocument(widget.uid),
              builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return const Center(
                    child: Text('Error'),
                  );
                }else{
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                         Stack(
                           children: [
                             CircleAvatar(
                              radius: 50,
                               backgroundImage:NetworkImage(_userProvider.photoUrl)
                                                     ),
                             const Positioned(
                               right: 0,
                               bottom: 0,
                               child: Icon(Icons.camera_alt, color: Colors.white, size: 30),
                             ),
                           ],
                         ),
                        const SizedBox(height: 10,),
                         TextButton(
                            onPressed:()async{
                              await pickImage();
                              if (imageFile.path.isNotEmpty) {
                                await _userProvider.changePhotoUrl(widget.uid, imageFile);
                              }
                            },
                            child: const Text('Change Avatar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              const SizedBox(height: 10,),
                              const Text('Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                               TextField(
                                enabled: _isEditing.value,
                                controller: _nameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: _userProvider.name,
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text('User Name',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                               TextField(
                                enabled: _isEditing.value,
                                controller: _userNameController,
                                decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: _userProvider.username,
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Text('Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                               TextField(
                                enabled: false,
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: '*********',
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
                              const SizedBox(height: 10,),
                              const SizedBox(height: 10,),
                              const Text('Email',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 10,),
                               TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  fillColor: Colors.black,
                                  hintText: _userProvider.email,
                                  hintStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                  disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2
                                      )
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30,),
                              ElevatedButton(onPressed: ()async{
                                if(_isEditing.value){
                                  _userProvider.updateProfile(
                                    uid: widget.uid,
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    username: _userNameController.text,
                                    currentPassword: _passwordController.text,
                                    newPassword: _newPasswordController.text,
                                  );
                                  _isEditing.value = false;
                                }else{
                                // _userProvider.deleteAccount(widget.uid);
                                // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                                  try {
                                    final databaseReference = FirebaseDatabase.instance.reference();
                                    await _userProvider.deleteAccount(widget.uid).then((value) {
                                      print("Deleted");
                                      databaseReference.child('users/${widget.uid}').remove().then((value) {
                                        print("Deleted");
                                        FirebaseAuth.instance.signOut();

                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false);
                                      });

                                    });
                                    // databaseReference.child('users/${widget.uid}').remove().then((value) {
                                    //   print("Deleted");
                                    //   FirebaseAuth.instance.signOut();
                                    //
                                    //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AuthPage()), (route) => false);
                                    // });

                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Failed to delete account: $error'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(const Size(400, 50)),
                                  side: _isEditing.value?MaterialStateProperty.all(const BorderSide(color: Colors.white)):
                                  MaterialStateProperty.all(const BorderSide(color: Colors.red)),
                                  backgroundColor: _isEditing.value?
                                  MaterialStateProperty.all(const Color(0xff6562df))
                                      : MaterialStateProperty.all(const Color(0xffbdbcfd)),
                                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                                ),
                                child:  Text(_isEditing.value?"Save Changes":"Delete Account",
                                  style:  TextStyle(color: _isEditing.value?Colors.white:Colors.red,fontSize: 18),),
                              )

                            ]
                        ),
                      ],
                    ),
                  );
                }

              }
            )
          );
        }, valueListenable: _isEditing,
      ),
    );
  }

  void _showBottomSheetForEdit(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Are you sure you want to edit your profile?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    // code here to handle the 'Yes' option

                    _isEditing.value = true;
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('No'),
                  onPressed: () {
                    // Put your code here to handle the 'No' option
                    _isEditing.value = false;
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

}
