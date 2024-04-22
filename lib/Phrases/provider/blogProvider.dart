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
  bool isSaved;
  final String seriesName;
  CardData({
    required this.documentId,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    required this.seriesName,
    bool? isSaved,
  }) : this.isSaved = isSaved ?? false;

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
  final String email;
  final List<CardData> savedPhrase;
  PhraseData({
    required this.email,
    required this.savedPhrase,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'savedPhrase': savedPhrase,
    };
  }

  factory PhraseData.fromJson(Map<String, dynamic> json) {
    return PhraseData(
      email: json['email'],
      savedPhrase: json['savedPhrase'],
    );
  }
}

class BlogProvider extends ChangeNotifier {
  List<CardData> _cardDataList = [];
  List<String> _seriesOptions = [];
  PhraseData _userPhraseProgress = PhraseData(email: '', savedPhrase: []);

  // void fetchSavedPhrasesForUser() async {
  //   try {
  //     // Get the current user
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       print("No user is signed in.");
  //       return;
  //     }

  //     String? email = user.email;
  //     if (email == null) {
  //       print("User email not available.");
  //       return;
  //     }

  //     // Fetch the user document from Firestore using email
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .where('email', isEqualTo: email)
  //         .limit(1) // Limiting the query to only return one document
  //         .get();

  //     // Check if there is at least one document in the query results
  //     if (querySnapshot.docs.isNotEmpty) {
  //       DocumentSnapshot userDoc = querySnapshot.docs.first;
  //       List<dynamic>? savedPhrasesData =
  //           userDoc['savedPhrases'] as List<dynamic>?;

  //       // Convert saved phrases data to a list of CardData objects
  //       List<CardData> savedPhrases = [];
  //       if (savedPhrasesData != null) {
  //         savedPhrases = savedPhrasesData.map((phrase) {
  //           return CardData.fromJson(Map<String, dynamic>.from(phrase));
  //         }).toList();
  //       }

  //       // Update PhraseData instance with the user's email and saved phrases
  //       _userPhraseProgress =
  //           PhraseData(email: email, savedPhrase: savedPhrases);

  //       // Notify listeners about the updated phrase progress
  //       notifyListeners();
  //     } else {
  //       _userPhraseProgress = PhraseData(email: email, savedPhrase: []);
  //       print("User document not found for email: $email");
  //     }
  //   } catch (error) {
  //     print("Error fetching saved phrases for user: $error");
  //   }
  // }

  void updateCardDataList(List<CardData> newCardDataList) {
    _cardDataList = newCardDataList;
    notifyListeners();
  }

  List<CardData> get cardDataList => _cardDataList;
  PhraseData get getUserPhraseProgress => _userPhraseProgress;
  List<String> get seriesOptions => _seriesOptions;

  Future<void> toggleSavedStatus(List<CardData> dataList, int index) async {
    try {
      bool isSaved = dataList[index].isSaved;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Conversations')
          .doc(dataList[index].documentId);

      // Check if the document exists before trying to update it
      DocumentSnapshot snapshot = await docRef.get();
      if (snapshot.exists) {
        await docRef.update({'isSaved': !isSaved});
        dataList[index].isSaved = !isSaved;
        notifyListeners();
      } else {
        print("Document not found: ${dataList[index].documentId}");
      }
    } catch (error) {
      print("Error updating saved status: $error");
    }
  }

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
      // Access the user's phrase progress
      PhraseData userPhraseProgress = _userPhraseProgress;

      // Check if the phrase is already saved
      bool isPhraseSaved = userPhraseProgress.savedPhrase
          .any((e) => e.englishText == phrase.englishText);

      // Toggle the saved phrase
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userPhraseProgress.email);

      if (isPhraseSaved) {
        // Remove the phrase from saved phrases
        userPhraseProgress.savedPhrase
            .removeWhere((e) => e.englishText == phrase.englishText);
        await userDocRef.update({
          'savedPhrases': FieldValue.arrayRemove([phrase.toJson()]),
        });
        print('Phrase unsaved successfully.');
      } else {
        // Add the phrase to saved phrases
        userPhraseProgress.savedPhrase.add(phrase);
        await userDocRef.update({
          'savedPhrases': FieldValue.arrayUnion([phrase.toJson()]),
        });
        print('Phrase saved successfully.');
      }

      // Notify listeners after updating the user document and phrase progress
      notifyListeners();
    } catch (error) {
      print('Error toggling saved phrase: $error');
    }
  }
}
