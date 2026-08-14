import '../models/analytics_model.dart';
import 'mock_data_service.dart';

class ReportService {
  final MockDataService _mock = MockDataService();

  Future<WeeklyReportModel> getWeeklyReport() async {
    final allTopics = _mock.subjects.expand((s) => s.allTopics).toList();
    final completed = allTopics.where((t) => t.isCompleted).length;
    final completedTasks = _mock.tasks.where((t) => t.isCompleted).length;

    return WeeklyReportModel(
      topicsCompleted: completed,
      tasksCompleted: completedTasks,
      totalStudyMinutes: completed * 45 + 90,
      xpEarned: _mock.currentUser.totalXp,
      averageQuizScore: 92.5,
      streakDays: _mock.userStreak.currentStreak,
      dailyCompletedTopics: [1, 0, 2, 1, 3, 2, 1], // Mon - Sun
      subjectMinutes: {
        'Mathematics': 120,
        'Computer Science': 150,
        'Database Management': 90,
        'Web & Mobile App Dev': 110,
        'AI': 60,
      },
    );
  }

  Future<String> exportReportSummary({required String format}) async {
    final report = await getWeeklyReport();
    return '''
==================================================
  GAMIFIED SYLLABUS TRACKER - PERFORMANCE REPORT
  Student: ${_mock.currentUser.name} (${_mock.currentUser.className})
  Format: $format | Date: ${DateTime.now().toLocal()}
==================================================
- Current Level: Level ${_mock.currentUser.currentLevel}
- Total XP: ${_mock.currentUser.totalXp} XP
- Active Streak: ${_mock.userStreak.currentStreak} Days 🔥
- Topics Completed: ${report.topicsCompleted}
- Total Study Time: ${report.totalStudyMinutes} Minutes
- Average Quiz Score: ${report.averageQuizScore}%
- Badges Earned: ${_mock.currentUser.badgesEarned}

Subject Time Breakdown:
${report.subjectMinutes.entries.map((e) => '  * ${e.key}: ${e.value} mins').join('\n')}

GLS University - Cross Platform Mobile Application Development
==================================================
''';
  }
}
