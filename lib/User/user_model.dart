import 'package:bfootlearn/Phrases/models/card_data.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String role;
  final String imageUrl;
  final int score;
  final int rank;
  final CardBadge badge;
  final List<SavedWords> savedWords;
  final List<CardData> savedPhrases;

  UserModel({
    required this.name,
    required this.email,
    required this.uid,
    required this.role,
    required this.imageUrl,
    required this.score,
    required this.rank,
    required this.savedWords,
    required this.savedPhrases,
    required this.badge,
  });

  String get getName => name;
  String get getEmail => email;
  String get getUid => uid;
  String get getRole => role;
  String get getImageUrl => imageUrl;
  int get getScore => score;
  int get getRank => rank;
  List<SavedWords> get getSavedWords => savedWords;
  List<CardData> get getSavedPhrases => savedPhrases;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
        'role': role,
        'imageUrl': imageUrl,
        'score': score,
        'rank': rank,
        "badge": badge.toJson(),
        'savedWords': savedWords.map((word) => word.toJson()).toList(),
        'savedPhrases': savedPhrases.map((phrase) => phrase.toJson()).toList(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      badge: CardBadge.fromJson(json["badge"]),
      name: json['name'],
      email: json['email'],
      uid: json['uid'],
      role: json['role'],
      imageUrl: json['imageUrl'],
      score: json['score'],
      rank: json['rank'],
      savedWords: (json['savedWords'] as List).map((item) {
        print("item to be added $item");
        return SavedWords.fromJson(item);
      }).toList(),
      savedPhrases: (json['savedPhrases'] as List).map((item) {
        print("item to be added $item");
        return CardData.fromJson(item);
      }).toList(),
    );
  }
  String getBadgeCategory() {
    if (badge.kinship) {
      return 'Kinship Terms';
    } else if (badge.dirrection) {
      return 'Directions and Time';
    } else if (badge.classroom) {
      return 'Classroom Commands';
    } else if (badge.time) {
      return 'Times of the day';
    } else {
      return 'No badge';
    }
  }
}

class CardBadge {
  final bool kinship;
  final bool dirrection;
  final bool classroom;
  final bool time;

  CardBadge({
    required this.kinship,
    required this.dirrection,
    required this.classroom,
    required this.time,
  });

  factory CardBadge.fromJson(Map<String, dynamic> json) => CardBadge(
        kinship: json["kinship"],
        dirrection: json["dirrection"],
        classroom: json["classroom"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "kinship": kinship,
        "dirrection": dirrection,
        "classroom": classroom,
        "time": time,
      };
}

class Words {
  final SavedWords data;

  Words({required this.data});

  factory Words.fromJson(Map<String, dynamic> json) {
    return Words(
      data: SavedWords.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class SavedWords {
  final String sound;
  final String english;
  final String blackfoot;

  SavedWords(
      {required this.sound, required this.english, required this.blackfoot});

  factory SavedWords.fromJson(Map<String, dynamic> json) {
    return SavedWords(
      sound: json['sound'],
      english: json['english'],
      blackfoot: json['blackfoot'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sound': sound,
        'english': english,
        'blackfoot': blackfoot,
      };
}
