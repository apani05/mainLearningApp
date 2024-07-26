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
    this.selectedAnswer,
    required this.isAudioTypeQuestion,
    required this.seriesType,
  }) : showCorrectAnswer = false;

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'correctAnswer': correctAnswer,
      'options': options,
      'selectedAnswer': selectedAnswer,
      'showCorrectAnswer': showCorrectAnswer,
      'isAudioTypeQuestion': isAudioTypeQuestion,
      'seriesType': seriesType,
    };
  }

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'],
      correctAnswer: json['correctAnswer'],
      options: List<String>.from(json['options']),
      selectedAnswer: json['selectedAnswer'],
      isAudioTypeQuestion: json['isAudioTypeQuestion'],
      seriesType: json['seriesType'],
    )..showCorrectAnswer = json['showCorrectAnswer'];
  }
}
