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

  List<CardData> getCardDataList() {
    return _cardDataList;
  }

  SavedData getUserPhraseProgress() {
    return _userPhraseProgress;
  }

  List<Map<String, dynamic>> getSeriesOptions() {
    return _seriesOptions;
  }

  void updateSeriesOptions(List<Map<String, dynamic>> seriesOptions) {
    _seriesOptions = seriesOptions;
    notifyListeners();
  }

  void updateCardDataList(List<CardData> newCardDataList) {
    _cardDataList = newCardDataList;
    notifyListeners();
  }

  Future<void> getSavedPhrases() async {
    List<CardData> savedPhrases = [];
    String uid = '';

    try {
      // Access Firestore collection 'users'
      String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: currentUserEmail)
              .get();

      querySnapshot.docs.forEach((doc) {
        List<dynamic> savedPhrasesData = doc.data()['savedPhrases'];
        uid = doc.data()['uid'];

        savedPhrasesData.forEach((phraseData) {
          CardData phrase = CardData(
            blackfootAudio: phraseData['blackfootAudio'],
            blackfootText: phraseData['blackfootText'],
            documentId: phraseData['documentId'],
            englishText: phraseData['englishText'],
            seriesName: phraseData['seriesName'],
          );
          savedPhrases.add(phrase);
        });
      });

      SavedData data = SavedData(
        uid: uid,
        savedPhrases: savedPhrases,
      );
      _userPhraseProgress = data;
    } catch (error) {
      print("Error fetching data: $error");
      rethrow;
    }

    // Notify listeners about the updated data
    notifyListeners();
  }

  Future<dynamic> getSeriesNamesFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ConversationTypes')
          .orderBy('seriesName')
          .get();

      List<Map<String, dynamic>> seriesOptions = querySnapshot.docs.map((doc) {
        return {
          'seriesName': doc['seriesName'],
          'iconImage': doc['iconImage'],
        };
      }).toList();
      _seriesOptions = seriesOptions;
      notifyListeners();
      return seriesOptions;
    } catch (error) {
      print("Error fetching series names: $error");
    }
    return;
  }

//
  // Future<List<CardData>> fetchDataGroupBySeriesName(String seriesName) async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('Conversations')
  //         .where('seriesName', isEqualTo: seriesName)
  //         .get();

  //     // Check if the query returned any documents
  //     if (querySnapshot.docs.isNotEmpty) {
  //       List<CardData> data = querySnapshot.docs.map((doc) {
  //         Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
  //         return CardData(
  //           documentId: doc.id,
  //           englishText: docData['englishText'],
  //           blackfootText: docData['blackfootText'],
  //           blackfootAudio: docData['blackfootAudio'],
  //           isSaved: docData['isSaved'],
  //           seriesName: seriesName,
  //         );
  //       }).toList();
  //       return data;
  //     } else {
  //       print("No documents found for series name: $seriesName");
  //       return [];
  //     }
  //   } catch (error) {
  //     print("Error fetching data: $error");
  //     rethrow;
  //   }
  // }

  ///
  List<CardData> filterDataBySeriesName(String seriesName) {
    return _cardDataList
        .where((data) => data.seriesName == seriesName)
        .toList();
  }

  Future<List<CardData>> fetchAllData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Conversations').get();

      if (querySnapshot.docs.isNotEmpty) {
        List<CardData> allData = querySnapshot.docs.map((doc) {
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
          return CardData(
            documentId: doc.id,
            englishText: docData['englishText'],
            blackfootText: docData['blackfootText'],
            blackfootAudio: docData['blackfootAudio'],
            seriesName: docData['seriesName'],
          );
        }).toList();
        updateCardDataList(allData);
        return allData;
      } else {
        print("Conversations collection is empty.");
        return [];
      }
    } catch (error) {
      print("Error fetching data: $error");
      rethrow;
    }
  }

  Future<void> toggleSavedPhrase(CardData phrase) async {
    try {
      // Check if the phrase is already saved
      bool isPhraseSaved = _userPhraseProgress.savedPhrases
          .any((e) => e.documentId == phrase.documentId);

      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userPhraseProgress.uid);

      DocumentSnapshot documentSnapshot = await userDocRef.get();

      if (documentSnapshot.exists) {
        // Update the user's saved phrases based on whether the phrase is already saved
        if (isPhraseSaved) {
          _userPhraseProgress.savedPhrases
              .removeWhere((e) => e.documentId == phrase.documentId);
          await userDocRef.update({
            'savedPhrases': FieldValue.arrayRemove([phrase.toJson()]),
          });
          print('Phrase unsaved successfully.');
        } else {
          _userPhraseProgress.savedPhrases.add(phrase);
          await userDocRef.update({
            'savedPhrases': FieldValue.arrayUnion([phrase.toJson()]),
          });
          print('Phrase saved successfully.');
        }

        // Notify listeners after updating the user document and phrase progress
        notifyListeners();
      } else {
        print('User document not found for UID: ${_userPhraseProgress.uid}');
      }
    } catch (error) {
      // Handle errors that may occur during the process
      print('Error toggling saved phrase: $error');
    }
  }

  Future<List<Quiz>> getUserQuizResults() async {
    List<Quiz> quizResults = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: _userPhraseProgress.uid)
              .get();

      querySnapshot.docs.forEach((doc) {
        List<dynamic> quizResultsData = doc.data()['quizResults'] ?? [];
        quizResultsData.forEach((quizData) {
          List<Question> questionSet = [];
          List<dynamic> questionsData = quizData['questionSet'] ?? [];
          questionsData.forEach((questionData) {
            Question question = Question(
              questionText: questionData['questionText'],
              correctAnswer: questionData['correctAnswer'],
              options: [],
              isAudioTypeQuestion: questionData['isAudioTypeQuestion'],
              seriesType: questionData['seriesType'],
            );
            question.selectedAnswer = questionData['selectedAnswer'];
            questionSet.add(question);
          });

          Quiz quiz = Quiz(
            dateSubmitted: quizData['dateSubmitted'],
            quizScore: quizData['quizScore'],
            totalPoints: quizData['totalPoints'],
            questionSet: questionSet,
          );
          quizResults.add(quiz);
        });
      });
    } catch (error) {
      print('Error fetching quiz results: $error');
    }
    return quizResults;
  }

// Save quiz results
  Future<void> saveQuizResults(int quizScore, List<Question> questions) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_userPhraseProgress.uid);

      Timestamp now = Timestamp.now();

      DocumentSnapshot documentSnapshot = await userDocRef.get();

      if (documentSnapshot.exists) {
        List<Map<String, dynamic>> questionSet = questions.map((question) {
          return {
            'questionText': question.questionText,
            'correctAnswer': question.correctAnswer,
            'selectedAnswer': question.selectedAnswer,
            'isAudioTypeQuestion': question.isAudioTypeQuestion,
            'seriesType': question.seriesType,
          };
        }).toList();

        await userDocRef.update({
          'quizResults': FieldValue.arrayUnion([
            {
              'dateSubmitted': now,
              'quizScore': quizScore,
              'totalPoints': questions.length,
              'questionSet': questionSet,
            }
          ]),
        });

        print('Quiz Results saved successfully.');
        notifyListeners();
      } else {
        print('User document not found for UID: ${_userPhraseProgress.uid}');
      }
    } catch (error) {
      // Handle errors that may occur during the process
      print('Error saving quiz results: $error');
    }
  }
}
