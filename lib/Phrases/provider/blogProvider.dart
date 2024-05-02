import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../riverpod/river_pod.dart';

class CardData {
  final String documentId;
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  final String seriesName;
  CardData({
    required this.documentId,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.seriesName,
  });

  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'englishText': englishText,
      'blackfootText': blackfootText,
      'blackfootAudio': blackfootAudio,
      'seriesName': seriesName,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      documentId: json['documentId'],
      englishText: json['englishText'],
      blackfootText: json['blackfootText'],
      blackfootAudio: json['blackfootAudio'],
      seriesName: json['seriesName'],
    );
  }
}

class PhraseData {
  final String uid;
  final List<CardData> savedPhrases;
  PhraseData({
    required this.uid,
    required this.savedPhrases,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'savedPhrases': savedPhrases,
    };
  }

  factory PhraseData.fromJson(Map<String, dynamic> json) {
    return PhraseData(
      uid: json['uid'],
      savedPhrases: json['savedPhrases'],
    );
  }
}

class BlogProvider extends ChangeNotifier {
  List<CardData> _cardDataList = [];
  List<String> _seriesOptions = [];
  PhraseData _userPhraseProgress = PhraseData(uid: '', savedPhrases: []);

  List<CardData> getCardDataList() {
    return _cardDataList;
  }

  PhraseData getUserPhraseProgress() {
    return _userPhraseProgress;
  }

  List<String> getSeriesOptions() {
    return _seriesOptions;
  }

  void updateCardDataList(List<CardData> newCardDataList) {
    _cardDataList = newCardDataList;
    notifyListeners();
  }

  Future<void> updatePhraseData() async {
    List<CardData> savedPhrases = [];
    String uid = '';

    try {
      // Access Firestore collection 'users'
      String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email',
                  isEqualTo: currentUserEmail) // Filter by user email
              .get();

      // Iterate through each document found
      querySnapshot.docs.forEach((doc) {
        // Get the 'savedPhrases' field from the document
        List<dynamic> savedPhrasesData = doc.data()['savedPhrases'];
        uid = doc.data()['uid'];

        // Iterate through each saved phrase and add it to the list
        savedPhrasesData.forEach((phraseData) {
          // Construct a CardData object from the data
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

      // Update the user phrase progress
      PhraseData data = PhraseData(
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
  // Future<void> toggleSavedStatus(List<CardData> dataList, int index) async {
  //   try {
  //     bool isSaved = dataList[index].isSaved;
  //     DocumentReference docRef = FirebaseFirestore.instance
  //         .collection('Conversations')
  //         .doc(dataList[index].documentId);

  //     // Check if the document exists before trying to update it
  //     DocumentSnapshot snapshot = await docRef.get();
  //     if (snapshot.exists) {
  //       await docRef.update({'isSaved': !isSaved});
  //       dataList[index].isSaved = !isSaved;
  //       notifyListeners();
  //     } else {
  //       print("Document not found: ${dataList[index].documentId}");
  //     }
  //   } catch (error) {
  //     print("Error updating saved status: $error");
  //   }
  // }

  Future<List<String>> getSeriesNamesFromFirestore() async {
    List<String> seriesNames = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ConversationTypes')
          .orderBy('seriesName')
          .get();

      seriesNames = querySnapshot.docs.map((doc) {
        String seriesName = doc['seriesName'];
        return seriesName;
      }).toList();
      _seriesOptions = seriesNames;
      notifyListeners();
      return seriesNames;
    } catch (error) {
      print("Error fetching series names: $error");
    }

    return seriesNames;
  }

  // Future<List<String>> fetchAllSeriesNames() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('ConversationTypes')
  //         .orderBy('seriesName')
  //         .get();

  //     // Check if the collection is not empty
  //     if (querySnapshot.docs.isNotEmpty) {
  //       List<String> seriesNames =
  //           querySnapshot.docs.map((doc) => doc.id).toList();
  //       return seriesNames;
  //     } else {
  //       print("ConversationTypes collection is empty.");
  //       return [];
  //     }
  //   } catch (error) {
  //     print("Error fetching series names: $error");
  //     rethrow;
  //   }
  // }

  // Future<String> fetchSeriesNameFromId(String? seriesName) async {
  //   try {
  //     DocumentSnapshot<Map<String, dynamic>> seriesNameSnapshot =
  //         await FirebaseFirestore.instance
  //             .collection('ConversationTypes')
  //             .doc(seriesName)
  //             .get();

  //     if (seriesNameSnapshot.exists) {
  //       String seriesName = seriesNameSnapshot.data()!['seriesName'];
  //       return seriesName;
  //     } else {
  //       print('Series name not found: ${seriesName}');
  //       return 'Series Not Found';
  //     }
  //   } catch (error) {
  //     print("Error fetching series name: $error");
  //     return 'Error Fetching Series Name';
  //   }
  // }

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
            seriesName: docData[
                'seriesName'], // Make sure you are setting the series name
          );
        }).toList();
        updateCardDataList(allData); // Update the provider list
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

      // Get the document snapshot from Firestore
      DocumentSnapshot documentSnapshot = await userDocRef.get();

      if (documentSnapshot.exists) {
        // Update the user's saved phrases based on whether the phrase is already saved
        if (isPhraseSaved) {
          // Remove the phrase from saved phrases
          _userPhraseProgress.savedPhrases
              .removeWhere((e) => e.documentId == phrase.documentId);
          await userDocRef.update({
            'savedPhrases': FieldValue.arrayRemove([phrase.toJson()]),
          });
          print('Phrase unsaved successfully.');
        } else {
          // Add the phrase to saved phrases
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
}
