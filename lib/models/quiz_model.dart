import 'question_model.dart';

class QuizAttemptModel {
  final int id;
  final int quizId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final int xpEarned;
  final DateTime attemptedAt;

  QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.xpEarned,
    required this.attemptedAt,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      quizId: json['quiz_id'] ?? json['quizId'] ?? 0,
      score: json['score'] ?? 0,
      totalQuestions: json['total_questions'] ?? json['totalQuestions'] ?? 5,
      percentage: (json['percentage'] is num) ? (json['percentage'] as num).toDouble() : 0.0,
      xpEarned: json['xp_earned'] ?? json['xpEarned'] ?? 15,
      attemptedAt: json['attempted_at'] != null
          ? DateTime.parse(json['attempted_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'score': score,
      'total_questions': totalQuestions,
      'percentage': percentage,
      'xp_earned': xpEarned,
      'attempted_at': attemptedAt.toIso8601String(),
    };
  }
}

class QuizModel {
  final int id;
  final int chapterId;
  final String subjectName;
  final String chapterName;
  final String title;
  final int xpReward;
  final List<QuestionModel> questions;
  final QuizAttemptModel? lastAttempt;

  QuizModel({
    required this.id,
    required this.chapterId,
    this.subjectName = '',
    this.chapterName = '',
    required this.title,
    this.xpReward = 15,
    this.questions = const [],
    this.lastAttempt,
  });

  bool get isAttempted => lastAttempt != null;

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    var rawQuestions = json['questions'];
    List<QuestionModel> parsedQuestions = [];
    if (rawQuestions is List) {
      parsedQuestions = rawQuestions
          .map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return QuizModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      chapterId: json['chapter_id'] ?? json['chapterId'] ?? 0,
      subjectName: json['subject_name'] ?? json['subjectName'] ?? '',
      chapterName: json['chapter_name'] ?? json['chapterName'] ?? '',
      title: json['title'] ?? '',
      xpReward: json['xp_reward'] ?? json['xpReward'] ?? 15,
      questions: parsedQuestions,
      lastAttempt: json['last_attempt'] != null
          ? QuizAttemptModel.fromJson(json['last_attempt'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'subject_name': subjectName,
      'chapter_name': chapterName,
      'title': title,
      'xp_reward': xpReward,
      'questions': questions.map((q) => q.toJson()).toList(),
      'last_attempt': lastAttempt?.toJson(),
    };
  }
}
