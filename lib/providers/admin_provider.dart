import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/announcement_model.dart';
import '../services/admin_service.dart';

class AdminProvider extends ChangeNotifier {
  final AdminService _service;

  List<UserModel> _users = [];
  List<AnnouncementModel> _announcements = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;

  AdminProvider({AdminService? service}) : _service = service ?? AdminService();

  List<UserModel> get users => _users;
  List<AnnouncementModel> get announcements => _announcements;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;

  Future<void> fetchAdminData() async {
    _isLoading = true;
    notifyListeners();

    _users = await _service.getAllUsers();
    _announcements = await _service.getAnnouncements();
    _stats = await _service.getOverallAcademicStatistics();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createAnnouncement({
    required String title,
    required String content,
    required String tag,
  }) async {
    await _service.createAnnouncement(
      title: title,
      content: content,
      tag: tag,
    );
    await fetchAdminData();
    return true;
  }
}
