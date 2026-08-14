class AppConstants {
  static const String appName = 'Gamified Syllabus Tracker';
  static const String appSubtitle = 'Level Up Your Academic Journey';
  static const String appVersion = '1.0.0';

  // Gamification Rules
  static const int xpPerTopicCompletion = 10;
  static const int xpPerHighPriorityTopic = 20;
  static const int xpPerQuizCompletion = 15;
  static const int xpPerPerfectQuiz = 25;
  static const int xpStreakBonus = 5;

  // Level Progression Thresholds
  static const List<Map<String, dynamic>> levelTiers = [
    {'level': 1, 'name': 'Beginner', 'minXp': 0, 'maxXp': 100, 'icon': '🌱'},
    {'level': 2, 'name': 'Learner', 'minXp': 100, 'maxXp': 250, 'icon': '📚'},
    {'level': 3, 'name': 'Explorer', 'minXp': 250, 'maxXp': 500, 'icon': '🚀'},
    {'level': 4, 'name': 'Achiever', 'minXp': 500, 'maxXp': 900, 'icon': '⭐'},
    {'level': 5, 'name': 'Scholar', 'minXp': 900, 'maxXp': 1500, 'icon': '🎓'},
    {'level': 6, 'name': 'Pro', 'minXp': 1500, 'maxXp': 99999, 'icon': '👑'},
  ];

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'auth_user';
  static const String themeKey = 'app_theme';
  static const String isFirstLaunchKey = 'is_first_launch';
}
