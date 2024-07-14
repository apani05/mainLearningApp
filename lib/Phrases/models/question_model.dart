class Question {
  String questionText;
  String correctAnswer;
  List<String> options;
  String? selectedAnswer;
  bool showCorrectAnswer;
  bool isAudioTypeQuestion;
  String seriesType;

  Question({
    required this.questionText,
    required this.correctAnswer,
    required this.options,
    required this.isAudioTypeQuestion,
    required this.seriesType,
  }) : showCorrectAnswer = false;
}
