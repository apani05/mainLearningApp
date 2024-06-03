import 'dart:io';

import 'package:bfootlearn/User/user_model.dart';
import 'package:bfootlearn/User/user_model.dart';
import 'package:bfootlearn/User/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';
  String _email = '';
  String _photoUrl = '';
  String _uid = '';
  String _token = '';
  String _refreshToken = '';
  String _expiresIn = '';
  int _score = 0;
  int _rank = 0;
  UserModel _user;
  int _heart = 0;

  String _username = "";

  UserProvider() : _user = UserModel(
    badge: CardBadge(kinship: false, dirrection: false, classroom: false, time: false),
    name: '',
    uid: '',
    imageUrl: '',
    score: 0,
    rank: 0,
    heart: 0,
    joinedDate: '',
    savedWords: [],
    userName: '',
    email: '',
  ); // Initialize _user in the constructor

  UserModel get user => _user;
  setUserData(UserModel user) {
    _user = user;
    notifyListeners();
  }
CardBadge _badge = CardBadge(kinship: false, dirrection: false, classroom: false, time: false);

  List<SavedWords> _savedWords = [];
  String get name => _name;

  String get email => _email;

  String get photoUrl => _photoUrl;

  String get uid => _uid;

  String get token => _token;

  String get refreshToken => _refreshToken;

  String get expiresIn => _expiresIn;

  int get score => _score;

  int get rank => _rank;

  int get heart => _heart;

  String get username => _username;

  List<SavedWords> get savedWords => _savedWords;

CardBadge get badge => _badge;

setBadge(CardBadge badge){
  _badge = badge;
  notifyListeners();
}
  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPhotoUrl(String photoUrl) {
    _photoUrl = photoUrl;
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setRefreshToken(String refreshToken) {
    _refreshToken = refreshToken;
    notifyListeners();
  }

  void setExpiresIn(String expiresIn) {
    _expiresIn = expiresIn;
    notifyListeners();
  }

  void setScore(int score) {
    _score = score;
    notifyListeners();
  }

  void setRank(int rank) {
    _rank = rank;
    notifyListeners();
  }

  void setHeart(int heart) {
    _heart = heart;
    notifyListeners();
  }

  void setWords(SavedWords words) {
    if (!_savedWords.contains(words)) {
      _savedWords.add(words);
      notifyListeners();
    }
  }

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void clear() {
    _name = '';
    _email = '';
    _photoUrl = '';
    _uid = '';
    _token = '';
    _refreshToken = '';
    _expiresIn = '';
    _score = 0;
    _rank = 0;
    _heart = 0;
    notifyListeners();
  }


  createUserInDb(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': user.name,
      'uid': user.uid,
      'imageUrl': user.imageUrl,
      'score': user.score,
      'rank': user.rank,
      'badge': user.badge.toJson(),
      'joinedDate': user.joinedDate,
      'heart': user.heart,
      'userName': user.userName,
      'email': user.email,
      'savedWords': user.savedWords.map((word) => word.toJson()).toList(),

    });
  }

  Future<bool>checkIfUserExistsInDb(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(documentSnapshot.exists){
     final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
     setEmail(user.email);
     setName(user.name);
      setUid(user.uid);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      setHeart(user.heart);
      setUsername(user.userName);
      print("badge is ${user.badge} and of type ${user.badge.runtimeType}");
      // user.savedWords.forEach((element) {
      //   setWords(element);
      // });
      //setWords(user.savedWords[0]);
print("user exists ${documentSnapshot.data()}");
    }
    return documentSnapshot.exists;
  }
 //get user from db while using app
  Future<UserModel> getUserFromDb(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print("user from db ${documentSnapshot.data()}");
    if(documentSnapshot.exists){
      final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      setUserData(user);
      setEmail(user.email);
      setName(user.name);
      setUid(user.uid);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      setHeart(user.heart);
      setUsername(user.userName);
      print("badge is ${user.badge} and of type ${user.badge.runtimeType}");
      // user.savedWords.forEach((element) {
      //   if(!_savedWords.contains(element))
      //   setWords(element);
      // });

    }
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }


  Future<void> updateBadge(String uid, CardBadge badge) async {
  setBadge(badge);
  print("badge to be updated ${badge.toJson()}");
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'badge': badge.toJson()
    });
  }
  Future<void>getSavedWords(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(documentSnapshot.exists){
      final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      _savedWords.clear();
      user.savedWords.forEach((element) {
        if(!_savedWords.contains(element))
          setWords(element);
      });

    }
   // return Data.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }
  removeWord(String word,String uid) async {
    int i = _savedWords.indexWhere((element) => element.blackfoot == word);
    print("deleting index $i");
    await removeWordFromUser( uid, _savedWords[i]);
    _savedWords.removeWhere((element) => element.blackfoot == word);
    notifyListeners();
  }
  Future<void> updateUserInDb(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': user.name,
      'uid': user.uid,
      'imageUrl': user.imageUrl,
      'score': user.score,
      'rank': user.rank,
      'savedWords': user.savedWords.map((word) => word.toJson()).toList(),

    });
  }
  
  Future<void> deleteUserFromDb(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).delete();
  }

  // Future<void> addWordToUser(String uid, Data word) async {
  //   await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //     'savedWords': FieldValue.arrayUnion([word.toJson()])
  //   });
  // }

  Future<void> addWordToUser(String uid, SavedWords word) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      UserModel user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      if (!user.savedWords.contains(word)) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'savedWords': FieldValue.arrayUnion([word.toJson()])
        });
      }
    }
  }
  Future<void> removeWordFromUser(String uid, SavedWords word) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'savedWords': FieldValue.arrayRemove([word.toJson()])
    });
  }

  Future<void> updateScore(String uid, int score) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'score': score
    });
  }

  Future<String> getScore(String uid) async {
    String v;
    v = await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['score']);
    return v;
  }

  Future<int> getRank(String uid) async {
    // Fetch all users
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

    // Sort the users based on score
    List<QueryDocumentSnapshot> users = querySnapshot.docs;
users.sort((a, b) {
  var aData = a.data() as Map<String, dynamic>?;
  var bData = b.data() as Map<String, dynamic>?;
  if (aData != null && bData != null) {
    return bData['score'].compareTo(aData['score']);
  }
  return 0;
});

    // Find the index of the current user
    int rank = 1;
    for (var doc in users) {
      if (doc.id == uid) {
        break;
      }
      rank++;
    }

    return rank;
  }

  updateRank(String uid, int rank) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'rank': rank
    });
  }

  getJoinDate(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['joindate']);
  }

  updateJoinDate(String uid, String date) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'joindate': date
    });
  }
  updateHeart(String uid, int heart) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'heart': heart
    });
  }
  getHeart(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['heart']);
  }
  Future<void> getBadge(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['badge']);
  }
  Future<void> changePassword(String email, String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        // If re-authentication is successful, update the password
        await user.updatePassword(newPassword);
        print("Password has been changed successfully");
      } catch (error) {
        print("Failed to change password: $error");
      }
    }
  }

  Future<void> changeEmail(String email, String password, String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);
        await user.reauthenticateWithCredential(credential);

        // If re-authentication is successful, update the email
        await user.updateEmail(newEmail);
        print("Email has been changed successfully");
      } catch (error) {
        print("Failed to change email: $error");
      }
    }
  }

  Future<void> changeName(String uid, String name) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name
    });
  }

  // Future<void> changePhotoUrl(String uid, String photoUrl) async {
  //   await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //     'imageUrl': photoUrl
  //   });
  // }

  Future<void> changePhotoUrl(String uid, File imageFile) async {
  try {
    // Upload the file to Firebase Storage
    Reference ref = FirebaseStorage.instance.ref().child('user_images').child('$uid.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);

    // Get the download URL of the uploaded file
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();

    // Update the user's photo URL in Firestore with the download URL
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'imageUrl': downloadUrl
    });

    print("Photo URL has been changed successfully");
  } catch (error) {
    print("Failed to change photo URL: $error");
  }
}

  Future<void> deleteAccount(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Delete the user's document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).delete();

        // Delete the user's account from Firebase Authentication
        await user.delete();
        print("Account has been deleted successfully");
      } catch (error) {
        print("Failed to delete account: $error");
      }
    }
  }

  void updateProfile({required String uid, required String name,
    required String username, required String email,required String currentPassword,required String newPassword}) async{

  print("updating profile with $uid $name $username $email $currentPassword $newPassword");
    FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'email': email,
      'userName': username,
      'uid': uid
    });
    await changePassword(email, currentPassword, newPassword);
  }

  Future<void> createFeedback({required String id, required String name, required String feedback}) async {
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'id': id,
      'name': name,
      'feedback': feedback,
      'timestamp': DateTime.now(),
    });
  }

}