import 'dart:io';
import 'package:bfootlearn/Phrases/models/card_data.dart';
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
  String _role = '';
  String _token = '';
  String _refreshToken = '';
  String _expiresIn = '';
  int _score = 0;
  int _rank = 0;
  UserModel _user;
  int _heart = 0;

  String _username = "";
  String _joinDate = "";

  UserProvider() :
      _badge = CardBadge(kinship: false, direction: false, classroom: false, time: false, weather: false),
        _user = UserModel(
    badge: CardBadge(kinship: false, direction: false, classroom: false, time: false, weather: false),
    name: '',
    uid: '',
    role: '',
    imageUrl: '',
    score: 0,
    rank: 0,
    heart: 0,
    joinedDate: '',
    savedWords: [],
    savedPhrases: [],
    userName: '',
    email: '',
  ); // Initialize _user in the constructor

  UserModel get user => _user;
  setUserData(UserModel user) {
    _user = user;
    notifyListeners();
  }
CardBadge _badge;

  List<SavedWords> _savedWords = [];
  List<CardData> _savedPhrases = [];
  String get name => _name;

  String get email => _email;

  String get photoUrl => _photoUrl;

  String get uid => _uid;

  String get role => _role;

  String get token => _token;

  String get refreshToken => _refreshToken;

  String get expiresIn => _expiresIn;

  int get score => _score;

  int get rank => _rank;

  int get heart => _heart;

  String get username => _username;


    String get joinDate => _joinDate;
    List<SavedWords> get savedWords => _savedWords;

  List<CardData> get savedPhrases => _savedPhrases;

  CardBadge get badge => _badge;

  setBadge(CardBadge badge) {
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

  void setRole(String role) {
    _role = role;
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

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setJoinedDate(String date) {
   _joinDate = date;
    notifyListeners();
  }

  void setWords(SavedWords words) {
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
    _role = '';
    _token = '';
    _refreshToken = '';
    _expiresIn = '';
    _score = 0;
    _rank = 0;
    _heart = 0;
    _joinDate = '';
    notifyListeners();
  }

  createUserInDb(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
      'role': user.role,
      'imageUrl': user.imageUrl,
      'score': user.score,
      'rank': user.rank,
      'badge': user.badge.toJson(),
      'joinedDate': user.joinedDate ,
      'heart': user.heart,
      'userName': user.userName,
      'email': user.email,
      'savedWords': user.savedWords?.map((word) => word.toJson()).toList(),
      'savedPhrases':
          user.savedPhrases.map((phrase) => phrase.toJson()).toList(),
    });
  }

  Future<bool>checkIfUserExistsInDb(String uid) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if(documentSnapshot.exists){
     final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
     setEmail(user.email);
     setName(user.name);
      setUid(user.uid);
      setRole(user.role.isEmpty?"user":user.role);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      setRole(role);
      setHeart(user.heart);
      setUsername(user.userName);
      print("badge is ${user.badge} and of type ${user.badge.runtimeType}");
      setPhrases(user.savedPhrases);
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
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    print("user from db ${documentSnapshot.data()}");
    if (documentSnapshot.exists) {
      final user =
          UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      setUserData(user);
      setEmail(user.email);
      setName(user.name);
      setUid(user.uid);
      setRole(user.role.isEmpty?"user":user.role);
      setPhotoUrl(user.imageUrl);
      setScore(user.score);
      setRank(user.rank);
      setHeart(user.heart);
      setUsername(user.userName);
      setJoinedDate(user.joinedDate);
      print("badge is ${user.badge} and of type ${user.badge.runtimeType}");
      // user.savedWords.forEach((element) {
      //   if(!_savedWords.contains(element))
      //   setWords(element);
      // });
    }
    return UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }
  
Future<UserModel> getUserProfile(String uid) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if(documentSnapshot.exists){
    final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    return user;
  }
  return UserModel(
    badge: CardBadge(kinship: false, direction: false, classroom: false, time: false, weather: false),
    name: '',
    uid: '',
    role: 'user',
    imageUrl: '',
    score: 0,
    rank: 0,
    heart: 0,
    joinedDate: '',
    savedWords: [],
    savedPhrases: [],
    userName: '',
    email: '',
  ); // Return a default UserModel when the document doesn't exist
}


  Future<void> updateBadge(String uid, CardBadge badge) async {
    setBadge(badge);
    print("badge to be updated ${badge.toJson()}");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'badge': badge.toJson()});
  }
  // Future<void>getSavedWords(String uid) async {
  //   DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   if(documentSnapshot.exists){
  //     final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  //     _savedWords.clear();
  //     user.savedWords.forEach((element) {
  //       if(!_savedWords.contains(element)) {
  //         setWords(element);
  //       }
  //     });
  //
  //   }
  //  // return Data.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  // }
  Future<void> getSavedWords(String uid, String category) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if(documentSnapshot.exists){
    final user = UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    _savedWords.clear();
    user.savedWords?.forEach((element) {
      if(element.cat == category && !_savedWords.contains(element)) {
        setWords(element);
      }
    });
  }
}

  removeWord(String word,String uid) async {
    int i = _savedWords.indexWhere((element) => element.blackfoot == word);
    print("deleting index $i");
    await removeWordFromUser(uid, _savedWords[i]);
    _savedWords.removeWhere((element) => element.blackfoot == word);
    notifyListeners();
  }

  Future<void> updateUserInDb(UserModel user, String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': user.name,
      'email': user.email,
      'uid': user.uid,
      'role': user.role.isEmpty?"user":user.role,
      'imageUrl': user.imageUrl,
      'score': user.score,
      'rank': user.rank,
      'savedWords': user.savedWords?.map((word) => word.toJson()).toList(),
      'savedPhrases':
          user.savedPhrases.map((phrase) => phrase.toJson()).toList(),
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

  Future<void> addWordToUser(String uid, SavedWords word,String cat) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      UserModel user =
          UserModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      if (!user.savedWords!.contains(word)) {
        word.cat = cat;
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'score': score});
  }

  Future<int> getScore(String uid) async {
    int v;
    v = await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['score']);
    return v;
  }

  Future<String> getRole(String uid) async {
    String v;
    v = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => value.data()!['role']);
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
        int aScore = aData['score'] ?? 0; // Use 0 if 'score' is null
        int bScore = bData['score'] ?? 0; // Use 0 if 'score' is null
        return bScore.compareTo(aScore);
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
    DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snapshot = await userDoc.get();
    if (snapshot.exists) {
      await userDoc.update({'rank': rank});
    } else {
      print('Document does not exist');
     // await userDoc.update({'rank': rank});
      await userDoc.set({
        'rank': rank,
      });
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'rank': rank});
  }

  updateJoinDate(String uid, String date) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'joindate': date});
  }

  Future<void> changePassword(
      String email, String currentPassword, String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        // If re-authentication is successful, update the password
        await user.updatePassword(newPassword);
        print("Password has been changed successfully");
      } catch (error) {
        print("Failed to change password: $error");
      }
    }
  }

  Future<void> changeEmail(
      String email, String password, String newEmail) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential =
            EmailAuthProvider.credential(email: email, password: password);
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'name': name});
  }

  Future<void> changePhotoUrl(String uid, File imageFile) async {
    try {
      // Upload the file to Firebase Storage
      Reference ref =
          FirebaseStorage.instance.ref().child('user_images').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(imageFile);

      // Get the download URL of the uploaded file
      String downloadUrl = await (await uploadTask).ref.getDownloadURL();

      // Update the user's photo URL in Firestore with the download URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'imageUrl': downloadUrl});

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

  void updateProfile(
      {required String uid,
      required String name,
      required String username,
      required String email,
      required String currentPassword,
      required String newPassword}) async {
    print(
        "updating profile with $uid $name $username $email $currentPassword $newPassword");
    FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'name': name, 'email': email, 'userName': username, 'uid': uid});
    await changePassword(email, currentPassword, newPassword);
  }

  Future<void> createFeedback(
      {required String id,
      required String name,
      required String feedback}) async {
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'id': id,
      'name': name,
      'feedback': feedback,
      'timestamp': DateTime.now(),
    });
  }

  getJoinDate(String uid) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['joindate']);
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
    //_badge = await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) => value.data()!['badge']);
    await FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      _badge = CardBadge.fromJson(value.data()!['badge']);
    });
  }

  // Future<void> changePhotoUrl(String uid, String photoUrl) async {
  //   await FirebaseFirestore.instance.collection('users').doc(uid).update({
  //     'imageUrl': photoUrl
  //   });
  // }

  List<String> _badgeCategories = [];
  List<String> get badgeCategories => _badgeCategories;

  setBadgeCategories(List<String> value) {
    _badgeCategories = value;
    notifyListeners(); // Notify listeners when badgeCategories changes
  }

  setCatagories() async {
    await getBadge(uid);
    CardBadge badge = this.badge;

    _badgeCategories.clear();

    if (badge.kinship) {
      _badgeCategories.add('Kinship Terms');
    }
    if (badge.direction) {
      _badgeCategories.add('Directions and Time');
    }
    if (badge.classroom) {
      _badgeCategories.add('Classroom Commands');
    }
    if (badge.time) {
      _badgeCategories.add('Times of the day');
    }
    if (badge.weather) {
      _badgeCategories.add('Weather');
    }

    notifyListeners(); // Notify listeners after setting categories
  }

  void setPhrases(List<CardData> savedPhrases) {
    _savedPhrases = savedPhrases;
    notifyListeners();
  }
}