// To parse this JSON data, do
//
//     final leaderBoardModel = leaderBoardModelFromJson(jsonString);

import 'dart:convert';

// LeaderBoardModel leaderBoardModelFromJson(String str) => LeaderBoardModel.fromJson(json.decode(str));
//
// String leaderBoardModelToJson(LeaderBoardModel data) => json.encode(data.toJson());

class LeaderBoardModel {
  final String name;
  final int score;

  LeaderBoardModel({
    required this.name,
    required this.score,
  });

  factory LeaderBoardModel.fromJson(Map json, bool isUser) {
    return LeaderBoardModel(
      name: isUser ? 'You' : json['name'],
      score: json['score'],
    );
  }
}
