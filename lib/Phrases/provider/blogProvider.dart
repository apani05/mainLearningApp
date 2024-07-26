import 'package:bfootlearn/Phrases/models/card_data.dart';
import 'package:bfootlearn/Phrases/models/question_model.dart';
import 'package:bfootlearn/Phrases/models/quiz_model.dart';
import 'package:bfootlearn/Phrases/models/saved_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BlogProvider extends ChangeNotifier {
  List<CardData> _cardDataList = [];
  List<Map<String, dynamic>> _seriesOptions = [];
  SavedData _userPhraseProgress = SavedData(uid: '', savedPhrases: []);
  Quiz _quizResults = Quiz.empty(); // Use the named constructor
  bool _isLoading = false;
  String? _errorMessage;

  List<CardData> get cardDataList => _cardDataList;
  List<Map<String, dynamic>> get seriesOptions => _seriesOptions;
  SavedData get userPhraseProgress => _userPhraseProgress;
  Quiz get quizResults => _quizResults; // Fixed this line
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<void> getSeriesNamesFromFirestore() async {
    setLoading(true);
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('series').get();
      _seriesOptions = snapshot.docs.map((doc) => doc.data()).toList();
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  List<CardData> filterDataBySeriesName(String seriesName) {
    print("card date for blog provider ${_cardDataList.length}");
    return _cardDataList
        .where((data) => data.seriesName == seriesName)
        .toList();
  }

  Future<void> fetchAllData() async {
    setLoading(true);
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('phrases').get();
      _cardDataList =
          snapshot.docs.map((doc) => CardData.fromJson(doc.data())).toList();
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  void toggleSavedPhrase(CardData phrase) {
    if (_userPhraseProgress.savedPhrases.contains(phrase)) {
      _userPhraseProgress.savedPhrases.remove(phrase);
    } else {
      _userPhraseProgress.savedPhrases.add(phrase);
    }
    notifyListeners();
  }

  Future<void> getSavedPhrases() async {
    setLoading(true);
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        _userPhraseProgress = SavedData(
          uid: userDoc.id,
          savedPhrases: [],
        );

        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('savedPhrases')
            .get();

        _userPhraseProgress = SavedData(
          uid: userDoc.id,
          savedPhrases: snapshot.docs
              .map((doc) => CardData.fromJson(doc.data()))
              .toList(),
        );
      }
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchQuizResultsFromFirebase() async {
    setLoading(true);
    try {
      String? email = FirebaseAuth.instance.currentUser?.email;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first;
        final snapshot = await FirebaseFirestore.instance
            .collection('quizResults')
            .where('userId', isEqualTo: userDoc.id)
            .get();

        // Process the snapshot data
        _quizResults = Quiz(
          dateSubmitted: snapshot.docs.first.data()['dateSubmitted'],
          quizScore: snapshot.docs.first.data()['quizScore'],
          totalPoints: snapshot.docs.first.data()['totalPoints'],
          questionSet: (snapshot.docs.first.data()['questionSet'] as List)
              .map((question) => Question.fromJson(question))
              .toList(),
        );
      }
      setError(null);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
    notifyListeners(); // Add notifyListeners to update the UI
  }

  Future<void> saveQuizResults(int quizScore, List<Question> questions) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userPhraseProgress.uid);

      Timestamp now = Timestamp.now();

      DocumentSnapshot documentSnapshot = await userDocRef.get();

      if (documentSnapshot.exists) {
        Quiz quiz = Quiz(
          dateSubmitted: now,
          quizScore: quizScore,
          totalPoints: questions.length,
          questionSet: questions,
        );

        await userDocRef.update({
          'quizResults': FieldValue.arrayUnion([quiz.toJson()]),
        });

        print('Quiz Results saved successfully.');
        notifyListeners();
      } else {
        print('User document not found for UID: ${_userPhraseProgress.uid}');
      }
    } catch (error) {
      print('Error saving quiz results: $error');
    }
  }

  void updateSeriesOptions(List<Map<String, dynamic>> seriesOptions) {
    _seriesOptions = seriesOptions;
    notifyListeners();
  }

  void updateCardDataList(List<CardData> newCardDataList) {
    _cardDataList = newCardDataList;
    notifyListeners();
  }

  void updateUserPhraseProgress(SavedData newUserPhraseProgress) {
    _userPhraseProgress = newUserPhraseProgress;
    notifyListeners();
  }
}
