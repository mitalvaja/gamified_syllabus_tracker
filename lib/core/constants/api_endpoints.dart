class ApiEndpoints {
  // Base configuration
  static const String baseUrl = 'http://localhost:5000/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String profile = '/auth/profile';

  // Syllabus endpoints
  static const String subjects = '/subjects';
  static const String chapters = '/chapters';
  static const String topics = '/topics';
  static String completeTopic(int topicId) => '/topics/$topicId/complete';

  // Planner endpoints
  static const String tasks = '/tasks';
  static String completeTask(int taskId) => '/tasks/$taskId/complete';
  static const String smartSuggestions = '/tasks/suggestions';

  // Progress endpoints
  static const String progressOverview = '/progress/overview';
  static const String subjectProgress = '/progress/subjects';

  // Gamification endpoints
  static const String gamification = '/gamification';
  static const String badges = '/badges';
  static const String streak = '/streak';
  static const String leaderboard = '/gamification/leaderboard';

  // Quiz endpoints
  static const String quizzes = '/quizzes';
  static String quizDetail(int quizId) => '/quizzes/$quizId';
  static String attemptQuiz(int quizId) => '/quizzes/$quizId/attempt';
  static const String weakTopics = '/quizzes/weak-topics';

  // Reports endpoints
  static const String weeklyReport = '/reports/weekly';
  static const String monthlyReport = '/reports/monthly';

  // Notifications & Announcements
  static const String notifications = '/notifications';
  static const String announcements = '/announcements';

  // Admin endpoints
  static const String adminUsers = '/admin/users';
  static const String adminPerformance = '/admin/performance';
  static const String adminSubjects = '/admin/subjects';
  static const String adminAnnouncements = '/admin/announcements';
}
