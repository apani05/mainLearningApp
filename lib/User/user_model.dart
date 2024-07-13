class UserModel {
  final String name;
  final String uid;
  final String imageUrl;
  final int score;
  final int rank;
  final int heart;
  final String email;
  final String userName;
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
    required this.email,
    required this.savedWords,
    required this.badge,
    required this.joinedDate,
    required this.userName
  });

  String get getName => name;
  String get getUid => uid;
  String get getImageUrl => imageUrl;
  int get getScore => score;
  int get getRank => rank;
  int get getHeart => heart;
  String get getJoinedDate => joinedDate;
  String get getUserName => userName;
  String get getEmail => email;
  List<SavedWords> get getSavedWords => savedWords;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'uid': uid,
        'imageUrl': imageUrl,
        'score': score,
        'rank': rank,
        'heart': heart,
        'userName': userName,
    "badge": badge.toJson(),
    'joinedDate': joinedDate,
        'savedWords': savedWords.map((word) => word.toJson()).toList(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      badge: CardBadge.fromJson(json["badge"]),
      name: json['name'],
      email: json['email']??'',
      uid: json['uid'],
      imageUrl: json['imageUrl'],
      score: json['score'],
      rank: json['rank'],
      heart: json['heart'],
      joinedDate: json['joindate']??DateTime.now().toString(),
      userName: json['userName']??'',
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
    } else if (badge.direction) {
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
  final bool direction;
  final bool classroom;
  final bool time;
  final bool weather;

  CardBadge({
    required this.kinship,
    required this.direction,
    required this.classroom,
    required this.time,
    required this.weather,
  });

  factory CardBadge.fromJson(Map<String, dynamic> json) => CardBadge(
    kinship: json["kinship"]??false,
    direction: json["direction"]??false,
    classroom: json["classroom"]??false,
    time: json["time"]??false,
    weather: json["weather"]??false,
  );

  Map<String, dynamic> toJson() => {
    "kinship": kinship,
    "direction": direction,
    "classroom": classroom,
    "time": time,
    "weather": weather,
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
   String cat;

  SavedWords({required this.sound, required this.english, required this.blackfoot,required this.cat});

  factory SavedWords.fromJson(Map<String, dynamic> json) {
    return SavedWords(
      sound: json['sound'],
      english: json['english'],
      blackfoot: json['blackfoot'],
      cat: json['cat']??'',
    );
  }

  Map<String, dynamic> toJson() => {
        'sound': sound,
        'english': english,
        'blackfoot': blackfoot,
        'cat':cat
      };
}