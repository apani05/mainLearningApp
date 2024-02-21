import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class vocabularyProvider extends ChangeNotifier {
  int _currentPage = 0;
  int get currentPage => _currentPage;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  set currentPage(int currentPage) {
    _currentPage = currentPage;
    notifyListeners();
  }

  double _lProgress = 0.0;
  double get lProgress => _lProgress;
  set lProgress(double lProgress) {
    _lProgress = lProgress;
    notifyListeners();
  }

  String _category = '';
  String get category => _category;
  set category(String category) {
    _category = category;
    notifyListeners();
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> get bottomNavigationKey => _bottomNavigationKey;

  // TabController _tabController = TabController(length: 3, vsync: ScrollableState());
  // TabController get tabController => _tabController;
  // set tabController(TabController tabController) {
  //   _tabController = tabController;
  //   notifyListeners();
  // }
  List<String> _vocabulary = [];
  List<String> get vocabulary => _vocabulary;
  set vocabulary(List<String> vocabulary) {
    _vocabulary = vocabulary;
    notifyListeners();
  }

  final CollectionReference vocabularyCollection =
  FirebaseFirestore.instance.collection('Vocabulary');


  setDocRef(String category) {
    final DocumentReference parentDocument =
    FirebaseFirestore.instance.doc('Vocabulary/$_category');
    return parentDocument;
  }


  Future<List<String>> getAllCategories() async {
    try {
      QuerySnapshot querySnapshot = await vocabularyCollection.get();

      List<String> categories = querySnapshot.docs.map((doc) => doc.id).toList();
      return categories;
    } catch (e) {
      print("Error getting categories: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDataByCategory(String category,String id,index) async {
    try {
      QuerySnapshot querySnapshot = await vocabularyCollection
          .doc(category)
          .collection("$id${index+1}")
          .get();

      List<Map<String, dynamic>> data =
      querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      print(data.first);
      return data;
    } catch (e) {
      print("Error getting data for category '$category': $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDataByCategory2(String category, String id) async {
  try {
    List<Map<String, dynamic>> allData = [];
    int index = 1;
    print("++++++++++++++++$id$index++++++++++++++++++++++");
    while (true) {
      QuerySnapshot querySnapshot = await vocabularyCollection
          .doc(category)
          .collection("$id$index")
          .get();

      if (querySnapshot.docs.isEmpty) {
        break;
      }

      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();


      allData.addAll(data);
      index++;
    }

    return allData;
  } catch (e) {
    print("Error getting data for category '$category': $e");
    return [];
  }
}
  getVocabulary() async {
    List<String> vocab = [];
    await firestore.collection("Vocabulary").
    get()
        .then((value) {
      value.docs.forEach((element) {
        vocab.add(element.data()["word"]);
      });
    });
    vocabulary = vocab;
  }

}