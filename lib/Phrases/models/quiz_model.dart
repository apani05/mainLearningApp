import 'package:cloud_firestore/cloud_firestore.dart';
import 'question_model.dart';

class Quiz {
  final Timestamp dateSubmitted;
  final int quizScore;
  final int totalPoints;
  final List<Question> questionSet;

  Quiz({
    required this.dateSubmitted,
    required this.quizScore,
    required this.totalPoints,
    required this.questionSet,
  });

  Map<String, dynamic> toJson() {
    return {
      'dateSubmitted': dateSubmitted,
      'quizScore': quizScore,
      'totalPoints': totalPoints,
      'questionSet': questionSet.map((q) => q.toJson()).toList(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      dateSubmitted: json['dateSubmitted'],
      quizScore: json['quizScore'],
      totalPoints: json['totalPoints'],
      questionSet: List<Question>.from(
          json['questionSet'].map((q) => Question.fromJson(q))),
    );
  }

  // Named constructor for creating an empty Quiz
  Quiz.empty()
      : dateSubmitted = Timestamp.now(),
        quizScore = 0,
        totalPoints = 0,
        questionSet = [];
}
