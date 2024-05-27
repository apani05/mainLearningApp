class QuizQuestion {
  final String id;
  final String? question;
  final String sound;
  final List<Option> options;
  final String quizType;
  final dynamic correctAnswer;
  final String audioLottie;

  QuizQuestion({
    required this.id,
    this.question,
    required this.sound,
    required this.options,
    required this.quizType,
    required this.correctAnswer,
    this.audioLottie = '',
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map, String id) {
    return QuizQuestion(
      id: id,
      question: map["question"], // Handle both 'question' and 'questions' keys
      sound: map['sound'],
      options: (map['options'] as List)
          .map((option) => Option.fromMap(option))
          .toList(),
      quizType: map['quiz_type'],
      correctAnswer: map['correctAnswer'],
      audioLottie: map['audioLottie']??'',
    );
  }
}

class Option {
  final String sound;
  final String word;
  final String lottie;

  Option({required this.sound, required this.word, this.lottie = ''});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      sound: map['sound']??'',
      word: map['word']??'',
      lottie: map['lottie']??'',
    );
  }
}
