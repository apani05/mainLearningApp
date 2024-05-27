import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String name;
  final String time;
  final String profileImage;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final String? shares;
  late final List<Comment>? replies;
  final List<Likes>? likesList;

  final String?id;

  Post({
     this.id,
    required this.name,
    required this.time,
    required this.profileImage,
    required this.content,
    this.imageUrl,
    required this.likes,
    required this.comments,
     this.shares,
     this.replies,
     this.likesList,
  });
  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id']??"",
      name: map['name'],
      time: map['time'].toDate().toString(),
      profileImage: map['profileImage'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      likes: map['likes'],
      comments: map['comments'],
      shares: map['shares']??"",
      replies: map['replies'] != null ?
      (map['replies'] as List)
          .map((reply) => Comment.fromMap(reply)).toList() : [],
      likesList: map['likesList'] != null ?
      (map['likesList'] as List)
          .map((like) => Likes.fromMap(like)).toList() : [],
    );

  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': Timestamp.fromDate(DateTime.parse(time)),
      'profileImage': profileImage,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'replies': replies?.map((reply) => reply.toMap()).toList(),
      //'likeList':likesList != null ? 'likesList': likesList?.map((like) => like.toMap()).toList(),
    };
  }


  Post copyWith({
    String? id,
    String? name,
    String? time,
    String? profileImage,
    String? content,
    String? imageUrl,
    int? likes,
    int? comments,
    String? shares,
    List<Comment>? replies,
    List<Likes>? likesList,
  }) {
    return Post(
      id: id ?? this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      profileImage: profileImage ?? this.profileImage,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      replies: replies ?? this.replies,
      likesList: likesList ?? this.likesList,
    );
  }

}

class Comment {
  final String name;
  final String time;
  final String content;
  final String profileImage;

  Comment({
    required this.name,
    required this.time,
    required this.content,
    required this.profileImage,
  });

  static Comment fromMap(Map<String, dynamic> map) {
    return Comment(
      name: map['name'],
      time: map['time'],
      content: map['content'],
      profileImage: map['profileImage']??FlutterLogo(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'content': content,
      'profileImage': profileImage,
    };
  }
}

class Likes {
  final String name;
  final String time;
  final String profileImage;

  Likes({
    required this.name,
    required this.time,
    required this.profileImage,
  });

  static Likes fromMap(Map<String, dynamic> map) {
    return Likes(
      name: map['name'],
      time: map['time'],
      profileImage: map['profileImage'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': time,
      'profileImage': profileImage,
    };
  }
}