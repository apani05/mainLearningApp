import 'card_data.dart';

class SavedData {
  final String uid;
  final List<CardData> savedPhrases;
  SavedData({
    required this.uid,
    required this.savedPhrases,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'savedPhrases': savedPhrases,
    };
  }

  factory SavedData.fromJson(Map<String, dynamic> json) {
    return SavedData(
      uid: json['uid'],
      savedPhrases: json['savedPhrases'],
    );
  }
}
