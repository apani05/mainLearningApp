import 'package:bfootlearn/User/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Data> _savedWords = [];
  String get name => _name;

  String get email => _email;

  String get photoUrl => _photoUrl;

  String get uid => _uid;

  String get token => _token;

  String get refreshToken => _refreshToken;

  String get expiresIn => _expiresIn;

  int get score => _score;

  int get rank => _rank;

  List<Data> get savedWords => _savedWords;

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

  void setWords(Data words) {
    if (!_savedWords.contains(words)) {
      _savedWords.add(words);
      notifyListeners();
    }
  }
  void clear() {
    _name = '';
    _email = '';
    _photoUrl = '';
    _uid = '';
    _token = '';
    _refreshToken = '';
    _expiresIn = '';
    notifyListeners();
  }


  createUserInDb(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': user.name,
      'uid': user.uid,
      'imageUrl': user.imageUrl,
      'score': user.score,
      'rank': user.rank,
      'savedWords': user.savedWords.map((word) => word.toJson()).toList(),

    });
  }

  Future<bool>checkIfUserExistsInDb(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(documentSnapshot.exists){
     final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
     setEmail(user.name);
      setUid(user.uid);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      // user.savedWords.forEach((element) {
      //   setWords(element);
      // });
      //setWords(user.savedWords[0]);

    }
    return documentSnapshot.exists;
  }

  Future<UserModel> getUserFromDb(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print("user from db ${documentSnapshot.data()}");
    if(documentSnapshot.exists){
      final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      setEmail(user.name);
      setUid(user.uid);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      // user.savedWords.forEach((element) {
      //   if(!_savedWords.contains(element))
      //   setWords(element);
      // });

    }
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
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
  removeWord(String word) async {
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

  Future<void> addWordToUser(String uid, Data word) async {
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
  Future<void> removeWordFromUser(String uid, Words word) async {
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

  Future<void> getRank(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['rank']);
  }
}