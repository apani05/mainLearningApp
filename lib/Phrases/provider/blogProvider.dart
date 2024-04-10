import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardData {
  final String documentId;
  final String englishText;
  final String blackfootText;
  final String blackfootAudio;
  bool isSaved;
  CardData({
    required this.documentId,
    required this.englishText,
    required this.blackfootText,
    required this.blackfootAudio,
    bool? isSaved,
  }) : this.isSaved =
            isSaved ?? false; // isSaved is null then its value is false
}

class BlogProvider extends ChangeNotifier {
  List<CardData> _cardDataList = [];

  void updateCardDataList(List<CardData> newCardDataList) {
    _cardDataList = newCardDataList;
    notifyListeners();
  }

  List<CardData> get cardDataList => _cardDataList;

  Future<void> toggleSavedStatus(int index) async {
    try {
      bool isSaved = _cardDataList[index].isSaved;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Conversations')
          .doc(_cardDataList[index].documentId);
      await docRef.update({'isSaved': !isSaved});
      _cardDataList[index].isSaved = !isSaved;
      notifyListeners();
    } catch (error) {
      print("Error updating saved status: $error");
    }
  }
}

final blogProvider = ChangeNotifierProvider<BlogProvider>((ref) {
  return BlogProvider();
});
Future<String> fetchSeriesName(String? seriesName) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> seriesNameSnapshot =
        await FirebaseFirestore.instance
            .collection('ConversationTypes')
            .doc(seriesName)
            .get();

    if (seriesNameSnapshot.exists) {
      String seriesName = seriesNameSnapshot.data()!['seriesName'];
      return seriesName;
    } else {
      print('Series name not found: ${seriesName}');
      return 'Series Not Found';
    }
  } catch (error) {
    print("Error fetching series name: $error");
    return 'Error Fetching Series Name';
  }
}

Future<List<CardData>> fetchDataGroupBySeriesName(
    Future<String> seriesNameFuture) async {
  try {
    String seriesName = await seriesNameFuture;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Conversations')
        .where('seriesName', isEqualTo: seriesName)
        .get();

    List<CardData> data = querySnapshot.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      return CardData(
        documentId: doc.id,
        englishText: docData['englishText'],
        blackfootText: docData['blackfootText'],
        blackfootAudio: docData['blackfootAudio'],
        isSaved: docData['isSaved'],
      );
    }).toList();
    return data;
  } catch (error) {
    print("Error fetching data: $error");
    rethrow;
  }
}

Future<List<CardData>> fetchAllData() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Conversations').get();

    List<CardData> allData = querySnapshot.docs.map((doc) {
      Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      return CardData(
        documentId: doc.id,
        englishText: docData['englishText'],
        blackfootText: docData['blackfootText'],
        blackfootAudio: docData['blackfootAudio'],
        isSaved: docData['isSaved'],
      );
    }).toList();

    return allData;
  } catch (error) {
    print("Error fetching data: $error");
    rethrow;
  }
}
