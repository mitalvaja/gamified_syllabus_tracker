import '../models/user_model.dart';
import '../models/announcement_model.dart';
import 'mock_data_service.dart';

class AdminService {
  final MockDataService _mock = MockDataService();

  Future<List<UserModel>> getAllUsers() async {
    return _mock.registeredUsers;
  }

  Future<List<AnnouncementModel>> getAnnouncements() async {
    return _mock.announcements;
  }

  Future<AnnouncementModel> createAnnouncement({
    required String title,
    required String content,
    required String tag,
  }) async {
    final announcement = AnnouncementModel(
      id: DateTime.now().millisecondsSinceEpoch,
      adminId: _mock.adminUser.id,
      authorName: _mock.adminUser.name,
      title: title,
      content: content,
      tag: tag,
      createdAt: DateTime.now(),
    );
    _mock.announcements.insert(0, announcement);
    return announcement;
  }

  Future<Map<String, dynamic>> getOverallAcademicStatistics() async {
    final allTopics = _mock.subjects.expand((s) => s.allTopics).toList();
    final totalTopics = allTopics.length;
    final completedTopics = allTopics.where((t) => t.isCompleted).length;

    return {
      'totalStudents': _mock.registeredUsers.length,
      'totalSubjects': _mock.subjects.length,
      'totalTopics': totalTopics,
      'averageCompletionRate': totalTopics == 0 ? 0 : ((completedTopics / totalTopics) * 100).round(),
      'activeStreaksAverage': 6.8,
      'quizzesAttemptedTotal': 48,
    };
  }
}
