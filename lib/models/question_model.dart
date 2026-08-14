class QuestionModel {
  final int id;
  final int quizId;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex; // 0, 1, 2, 3
  final String explanation;

  QuestionModel({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    this.explanation = '',
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    List<String> opts = [];
    if (json['options'] is List) {
      opts = (json['options'] as List).map((e) => e.toString()).toList();
    } else {
      opts = [
        json['option_a'] ?? '',
        json['option_b'] ?? '',
        json['option_c'] ?? '',
        json['option_d'] ?? '',
      ];
    }

    int correctIdx = 0;
    if (json['correct_answer'] is int) {
      correctIdx = json['correct_answer'];
    } else if (json['correct_answer'] is String) {
      final ans = (json['correct_answer'] as String).toLowerCase();
      if (ans == 'a' || ans == 'option_a') correctIdx = 0;
      else if (ans == 'b' || ans == 'option_b') correctIdx = 1;
      else if (ans == 'c' || ans == 'option_c') correctIdx = 2;
      else if (ans == 'd' || ans == 'option_d') correctIdx = 3;
      else correctIdx = int.tryParse(ans) ?? 0;
    }

    return QuestionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      quizId: json['quiz_id'] ?? json['quizId'] ?? 0,
      questionText: json['question'] ?? json['questionText'] ?? '',
      options: opts,
      correctOptionIndex: correctIdx,
      explanation: json['explanation'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question': questionText,
      'options': options,
      'correct_answer': correctOptionIndex,
      'explanation': explanation,
    };
  }
}
