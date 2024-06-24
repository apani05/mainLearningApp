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
}
