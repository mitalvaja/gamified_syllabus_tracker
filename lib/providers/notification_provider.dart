import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service;

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  NotificationProvider({NotificationService? service}) : _service = service ?? NotificationService() {
    fetchNotifications();
  }

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoading => _isLoading;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    notifyListeners();

    _notifications = await _service.getNotifications();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    await _service.markAllAsRead();
    await fetchNotifications();
  }

  Future<void> scheduleReminder({
    required String subjectName,
    required DateTime scheduledTime,
  }) async {
    await _service.scheduleStudyReminder(
      subjectName: subjectName,
      scheduledTime: scheduledTime,
    );
    await fetchNotifications();
  }
}
