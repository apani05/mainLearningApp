class UserModel {
  final String name;
  final String uid;
  final String imageUrl;
  final int score;
  final int rank;
  final int heart;
  final CardBadge badge;
  final String joinedDate ;
  final List<SavedWords> savedWords;

  UserModel({
    required this.name,
    required this.uid,
    required this.imageUrl,
    required this.score,
    required this.rank,
    required this.heart,
    required this.savedWords,
    required this.badge,
    required this.joinedDate
  });

  String get getName => name;
  String get getUid => uid;
  String get getImageUrl => imageUrl;
  int get getScore => score;
  int get getRank => rank;
  int get getHeart => heart;
  String get getJoinedDate => joinedDate;
  List<SavedWords> get getSavedWords => savedWords;

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'imageUrl': imageUrl,
        'score': score,
        'rank': rank,
        'heart': heart,
    "badge": badge.toJson(),
    'joinedDate': joinedDate,
        'savedWords': savedWords.map((word) => word.toJson()).toList(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      badge: CardBadge.fromJson(json["badge"]),
      name: json['name'],
      uid: json['uid'],
      imageUrl: json['imageUrl'],
      score: json['score'],
      rank: json['rank'],
      heart: json['heart'],
      joinedDate: json['joindate'],
      savedWords: (json['savedWords'] as List)
          .map((item) {
            print("item to be added $item");
            return SavedWords.fromJson(item);
          })
          .toList(),
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

  SavedWords({required this.sound, required this.english, required this.blackfoot});

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