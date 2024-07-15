import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/quiz_model.dart';

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

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;
  set isDownloading(bool isDownloading) {
    _isDownloading = isDownloading;
    notifyListeners();
  }
  String _titleId = '';
  String get titleId => _titleId;
  set titleId(String titleId) {
    switch (titleId) {
      case 'ueEFv1EI9xm9ciT8u2vt' || 'Classroom Commands':
        titleId = 'ueEFv1EI9xm9ciT8u2vt';
        break;
      case 'Practice':
        _currentPage = 1;
        break;
      case 'Saved':
        _currentPage = 2;
        break;
    }
    print("title to be set is $titleId");
    //_titleId = titleId;
    notifyListeners();
  }

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  GlobalKey<CurvedNavigationBarState> get bottomNavigationKey =>
      _bottomNavigationKey;

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

      List<String> categories =
          querySnapshot.docs.map((doc) => doc.id).toList();
      return categories;
    } catch (e) {
      print("Error getting categories: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDataByCategory(
      String category, String id, index) async {
    try {
      QuerySnapshot querySnapshot = await vocabularyCollection
          .doc(category)
          .collection("$id${index + 1}")
          .get();

      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      print(data.first);
      return data;
    } catch (e) {
      print("Error getting data for category '$category': $e");
      return [];
    }
  }

//   Future<List<Map<String, dynamic>>> getDataByCategory2(String category, String id) async {
//   try {
//     List<Map<String, dynamic>> allData = [];
//     int index = 1;
//     print("++++++++++++++++$id$index++++++++++++++++++++++");
//     while (true) {
//       QuerySnapshot querySnapshot = await vocabularyCollection
//           .doc(category)
//           .collection("$id$index")
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         break;
//       }
//
//       List<Map<String, dynamic>> data = querySnapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//
//
//       allData.addAll(data);
//       index++;
//     }
//
//     return allData;
//   } catch (e) {
//     print("Error getting data for category '$category': $e");
//     return [];
//   }
// }

Future<List<Map<String, dynamic>>> getDataByCategory2(String category, String id) async {
  try {
    List<Map<String, dynamic>> allData = [];
    int index = 1;
    while (true) {
      String formattedIndex = index.toString().padLeft(2, '0');
      print("++++++++++++++++$id$formattedIndex++++++++++++++++++++++");
      QuerySnapshot querySnapshot = await vocabularyCollection
          .doc(category)
          .collection("$id$formattedIndex")
          .get();

      if (querySnapshot.docs.isEmpty) {
        // If no data found with the padded index, check for the unpadded index
        querySnapshot = await vocabularyCollection
            .doc(category)
            .collection("$id$index")
            .get();

        if (querySnapshot.docs.isEmpty) {
          break;
        }
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
    await firestore.collection("Vocabulary").get().then((value) {
      value.docs.forEach((element) {
        vocab.add(element.data()["word"]);
      });
    });
    vocabulary = vocab;
  }

  //quiz from firebase

 Future<List<QuizQuestion>> fetchQuestions(String category) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<QuizQuestion> questionsList = [];

  try {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot = await firestore.collection('quiz').doc(category).get();
   // QuerySnapshot querySnapshot = await firestore.collection('quiz').doc('kinship terms').get();
    print("qustions are from category ${documentSnapshot.data()}");
   //print("qustions are from category ${}");
    for (var doc in documentSnapshot.data()!.entries) {
      Map<String, dynamic> data = doc.value;
     // print("data to be transformed is $data is ${doc.value}question is ${question.question}");
      questionsList.add(QuizQuestion.fromMap(data, doc.key));
    }
  } catch (e) {
    print("Error fetching data: $e");
  }
  return questionsList;
}

  String _selectedAnswer = '';
  String get selectedAnswer => _selectedAnswer;
  set selectedAnswer(String selectedAnswer) {
    _selectedAnswer = selectedAnswer;
    notifyListeners();
  }
  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;
  set isAnswered(bool isAnswered) {
    _isAnswered = isAnswered;
    notifyListeners();
  }

  void selectAnswer(String selectedAnswer) {
    if (!_isAnswered) {
      _isAnswered = true;
      _selectedAnswer = selectedAnswer;
      notifyListeners();
    }
  }

  int _currentQuestionIndex = 0;
  int _score = 0;
  List<QuizQuestion> _questions = [];

  void nextQuestion(int qLength) {
    if (_currentQuestionIndex < qLength - 1) {
      _currentQuestionIndex++;
      _isAnswered = false;
    } else {
      print('Quiz completed!');
      _score = 0; // Reset score for next quiz
    }
    notifyListeners();
  }

  int _scoreT = 0;
  int _index = 0;
  int _scoreIndex = 0;
  double _progress = 0.0;
  int _cardsFlipped = 0;
  bool _isPlaying = false;
  String _categoryT = '';

  int get score => _scoreT;
  int get index => _index;
  int get scoreIndex => _scoreIndex;
  double get progress => _progress;
  int get cardsFlipped => _cardsFlipped;
  bool get isPlaying => _isPlaying;
  String get categoryT => _categoryT;

  set score(int score) {
    _scoreT = score;
    notifyListeners();
  }

  set index(int index) {
    _index = index;
    notifyListeners();
  }
  set scoreIndex(int scoreIndex) {
    _scoreIndex = scoreIndex;
    notifyListeners();
  }
  set progress(double progress) {
    _progress = progress;
    notifyListeners();
  }
  set cardsFlipped(int cardsFlipped) {
    _cardsFlipped = cardsFlipped;
    notifyListeners();
  }
  set isPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  set categoryT(String categoryT) {
    _categoryT = categoryT;
    notifyListeners();
  }

  void resetGame() {
    _scoreT = 0;
    _index = 0;
    _scoreIndex = 0;
    _progress = 0.0;
    _cardsFlipped = 0;
    _isPlaying = false;
    notifyListeners();
  }

  Map<String, Map<String, dynamic>> categoryValues = {};

  // Method to store the values for a specific category
  void storeValuesForCategory(String category) {
    categoryValues[category] = {
      'index': index,
      'scoreIndex': scoreIndex,
      'score': score,
      'progress': progress,
      'cardsFlipped': cardsFlipped,
      'isPlaying': isPlaying,
      'lProgress': lProgress,
    };
    notifyListeners();
  }

  // Method to retrieve the values for a specific category
  Map<String, dynamic> getValuesForCategory(String category) {
    return categoryValues[category] ?? {};
  }
  Map<String,dynamic> setValuesForCategory(String category) {
    return categoryValues[category] ?? {};
  }
}