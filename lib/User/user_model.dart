class UserModel {
  final String name;
  final String uid;
  final String imageUrl;
  final int score;
  final int rank;
  final List<Data> savedWords;

  UserModel({
    required this.name,
    required this.uid,
    required this.imageUrl,
    required this.score,
    required this.rank,
    required this.savedWords,
  });

  String get getName => name;
  String get getUid => uid;
  String get getImageUrl => imageUrl;
  int get getScore => score;
  int get getRank => rank;
  List<Data> get getSavedWords => savedWords;

  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
        'imageUrl': imageUrl,
        'score': score,
        'rank': rank,
        'savedWords': savedWords.map((word) => word.toJson()).toList(),
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      uid: json['uid'],
      imageUrl: json['imageUrl'],
      score: json['score'],
      rank: json['rank'],
      savedWords: (json['savedWords'] as List)
          .map((item) {
            print("item to be added $item");
            return Data.fromJson(item);
          })
          .toList(),
    );
  }
}

class Words {
  final Data data;

  Words({required this.data});

  factory Words.fromJson(Map<String, dynamic> json) {
    return Words(
      data: Data.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class Data {
  final String sound;
  final String english;
  final String blackfoot;

  Data({required this.sound, required this.english, required this.blackfoot});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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