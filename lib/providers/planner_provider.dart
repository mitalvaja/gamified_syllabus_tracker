import 'package:flutter/foundation.dart';
import '../models/study_task_model.dart';
import '../services/planner_service.dart';
import 'gamification_provider.dart';

class PlannerProvider extends ChangeNotifier {
  final PlannerService _service;

  List<StudyTaskModel> _tasks = [];
  List<Map<String, dynamic>> _smartSuggestions = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String? _errorMessage;

  PlannerProvider({PlannerService? service}) : _service = service ?? PlannerService();

  List<StudyTaskModel> get tasks => _tasks;
  List<Map<String, dynamic>> get smartSuggestions => _smartSuggestions;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<StudyTaskModel> get selectedDateTasks {
    return _tasks.where((t) =>
        t.date.year == _selectedDate.year &&
        t.date.month == _selectedDate.month &&
        t.date.day == _selectedDate.day).toList();
  }

  int get todayCompletedCount => selectedDateTasks.where((t) => t.isCompleted).length;
  int get todayTotalCount => selectedDateTasks.length;
  double get todayProgress => todayTotalCount == 0 ? 0.0 : (todayCompletedCount / todayTotalCount);

  void setDate(DateTime date) {
    _selectedDate = date;
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final res = await _service.getTasks();
    if (res.success && res.data != null) {
      _tasks = res.data!;
    } else {
      _errorMessage = res.message;
    }

    _smartSuggestions = await _service.getSmartSuggestions();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addTask({
    int? topicId,
    required String subjectName,
    required String topicName,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String priority,
  }) async {
    final res = await _service.addTask(
      topicId: topicId,
      subjectName: subjectName,
      topicName: topicName,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      priority: priority,
    );

    if (res.success) {
      await fetchTasks();
      return true;
    }
    return false;
  }

  Future<bool> toggleTaskCompletion({
    required int taskId,
    required bool isCompleted,
    required String priority,
    required String subjectName,
    GamificationProvider? gamificationProvider,
  }) async {
    final res = await _service.toggleTaskCompletion(taskId, isCompleted);
    if (res.success) {
      if (isCompleted && gamificationProvider != null) {
        await gamificationProvider.onTopicCompleted(
          priority: priority,
          subjectName: subjectName,
        );
      }
      await fetchTasks();
      return true;
    }
    return false;
  }

  Future<bool> deleteTask(int taskId) async {
    final res = await _service.deleteTask(taskId);
    if (res.success) {
      _tasks.removeWhere((t) => t.id == taskId);
      notifyListeners();
      return true;
    }
    return false;
  }
}
