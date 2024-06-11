import '../Phrases/provider/blogProvider.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;
  final String role;
  final String imageUrl;
  final int score;
  final int rank;
  final int heart;
  final String userName;
  final CardBadge badge;
  final String joinedDate;
  final List<SavedWords> savedWords;
  final List<CardData> savedPhrases;

  UserModel(
      {required this.name,
      required this.email,
      required this.uid,
      required this.role,
      required this.imageUrl,
      required this.score,
      required this.rank,
      required this.heart,
      required this.savedWords,
      required this.savedPhrases,
      required this.badge,
      required this.joinedDate,
      required this.userName});
  String get getName => name;
  String get getEmail => email;
  String get getUid => uid;
  String get getRole => role;
  String get getImageUrl => imageUrl;
  int get getScore => score;
  int get getRank => rank;
  int get getHeart => heart;
  String get getJoinedDate => joinedDate;
  String get getUserName => userName;
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
        'heart': heart,
        'userName': userName,
        'badge': badge.toJson(),
        'joinedDate': joinedDate,
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
      heart: json['heart'],
      joinedDate: json['joindate'],
      userName: json['userName'],
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
