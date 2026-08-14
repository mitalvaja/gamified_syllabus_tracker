class WeeklyReportModel {
  final int topicsCompleted;
  final int tasksCompleted;
  final int totalStudyMinutes;
  final int xpEarned;
  final double averageQuizScore;
  final int streakDays;
  final List<int> dailyCompletedTopics; // 7 days (Mon-Sun)
  final Map<String, int> subjectMinutes;

  WeeklyReportModel({
    this.topicsCompleted = 0,
    this.tasksCompleted = 0,
    this.totalStudyMinutes = 0,
    this.xpEarned = 0,
    this.averageQuizScore = 0.0,
    this.streakDays = 0,
    this.dailyCompletedTopics = const [0, 0, 0, 0, 0, 0, 0],
    this.subjectMinutes = const {},
  });

  factory WeeklyReportModel.fromJson(Map<String, dynamic> json) {
    List<int> daily = [0, 0, 0, 0, 0, 0, 0];
    if (json['daily_completed_topics'] is List) {
      daily = (json['daily_completed_topics'] as List)
          .map((e) => (e is int) ? e : int.tryParse(e.toString()) ?? 0)
          .toList();
    }

    Map<String, int> subMins = {};
    if (json['subject_minutes'] is Map) {
      (json['subject_minutes'] as Map).forEach((k, v) {
        subMins[k.toString()] = (v is int) ? v : int.tryParse(v.toString()) ?? 0;
      });
    }

    return WeeklyReportModel(
      topicsCompleted: json['topics_completed'] ?? 0,
      tasksCompleted: json['tasks_completed'] ?? 0,
      totalStudyMinutes: json['total_study_minutes'] ?? 0,
      xpEarned: json['xp_earned'] ?? 0,
      averageQuizScore: (json['average_quiz_score'] is num)
          ? (json['average_quiz_score'] as num).toDouble()
          : 0.0,
      streakDays: json['streak_days'] ?? 0,
      dailyCompletedTopics: daily,
      subjectMinutes: subMins,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topics_completed': topicsCompleted,
      'tasks_completed': tasksCompleted,
      'total_study_minutes': totalStudyMinutes,
      'xp_earned': xpEarned,
      'average_quiz_score': averageQuizScore,
      'streak_days': streakDays,
      'daily_completed_topics': dailyCompletedTopics,
      'subject_minutes': subjectMinutes,
    };
  }
}

class LeaderboardEntryModel {
  final int rank;
  final int userId;
  final String name;
  final String className;
  final int totalXp;
  final int level;
  final int badgesCount;

  LeaderboardEntryModel({
    required this.rank,
    required this.userId,
    required this.name,
    required this.className,
    required this.totalXp,
    required this.level,
    required this.badgesCount,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json['rank'] ?? 1,
      userId: json['user_id'] ?? json['userId'] ?? 0,
      name: json['name'] ?? '',
      className: json['class'] ?? json['className'] ?? 'BCA Sem V',
      totalXp: json['total_xp'] ?? json['totalXp'] ?? 0,
      level: json['level'] ?? 1,
      badgesCount: json['badges_count'] ?? json['badgesCount'] ?? 0,
    );
  }
}
