import '../models/notification_model.dart';
import 'mock_data_service.dart';

class NotificationService {
  final MockDataService _mock = MockDataService();

  Future<List<NotificationModel>> getNotifications() async {
    return _mock.notifications;
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _mock.notifications.length; i++) {
      _mock.notifications[i] = NotificationModel(
        id: _mock.notifications[i].id,
        userId: _mock.notifications[i].userId,
        title: _mock.notifications[i].title,
        message: _mock.notifications[i].message,
        type: _mock.notifications[i].type,
        isRead: true,
        createdAt: _mock.notifications[i].createdAt,
      );
    }
  }

  Future<void> scheduleStudyReminder({
    required String subjectName,
    required DateTime scheduledTime,
  }) async {
    final newNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1,
      title: 'Study Reminder: $subjectName 📖',
      message: 'Your planned study session for $subjectName starts soon. Stay consistent!',
      type: 'reminder',
      isRead: false,
      createdAt: DateTime.now(),
    );
    _mock.notifications.insert(0, newNotif);
  }
}
