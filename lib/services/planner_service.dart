import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../core/utils/date_formatter.dart';
import '../models/study_task_model.dart';
import '../models/topic_model.dart';
import 'mock_data_service.dart';

class PlannerService {
  final ApiClient _apiClient;
  final MockDataService _mock = MockDataService();

  PlannerService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ApiResponse<List<StudyTaskModel>>> getTasks({DateTime? date}) async {
    final response = await _apiClient.get<List<StudyTaskModel>>(
      ApiEndpoints.tasks,
      fromJson: (data) => (data as List).map((i) => StudyTaskModel.fromJson(i)).toList(),
    );

    if (response.success && response.data != null) {
      if (date != null) {
        final filtered = response.data!.where((t) =>
            t.date.year == date.year &&
            t.date.month == date.month &&
            t.date.day == date.day).toList();
        return ApiResponse.success(filtered);
      }
      return response;
    }

    if (date != null) {
      final filtered = _mock.tasks.where((t) =>
          t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day).toList();
      return ApiResponse.success(filtered);
    }
    return ApiResponse.success(_mock.tasks);
  }

  Future<ApiResponse<StudyTaskModel>> addTask({
    int? topicId,
    required String subjectName,
    required String topicName,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String priority,
  }) async {
    final response = await _apiClient.post<StudyTaskModel>(
      ApiEndpoints.tasks,
      body: {
        'topic_id': topicId,
        'subject_name': subjectName,
        'topic_name': topicName,
        'date': date.toIso8601String(),
        'start_time': startTime,
        'duration': durationMinutes,
        'priority': priority,
      },
      fromJson: (data) => StudyTaskModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final newTask = StudyTaskModel(
      id: DateTime.now().millisecondsSinceEpoch,
      userId: 1,
      topicId: topicId,
      subjectName: subjectName,
      topicName: topicName,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      priority: priority,
      status: 'pending',
    );
    _mock.tasks.insert(0, newTask);
    return ApiResponse.success(newTask, message: 'Study task scheduled!');
  }

  Future<ApiResponse<StudyTaskModel>> toggleTaskCompletion(int taskId, bool isCompleted) async {
    final response = await _apiClient.patch<StudyTaskModel>(
      ApiEndpoints.completeTask(taskId),
      body: {'is_completed': isCompleted},
      fromJson: (data) => StudyTaskModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final idx = _mock.tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final updated = _mock.tasks[idx].copyWith(
        status: isCompleted ? 'completed' : 'pending',
        completedAt: isCompleted ? DateTime.now() : null,
      );
      _mock.tasks[idx] = updated;
      return ApiResponse.success(updated);
    }
    return ApiResponse.error('Task not found');
  }

  Future<ApiResponse<bool>> deleteTask(int taskId) async {
    final response = await _apiClient.delete<bool>(
      '${ApiEndpoints.tasks}/$taskId',
      fromJson: (data) => true,
    );
    if (response.success) return response;

    _mock.tasks.removeWhere((t) => t.id == taskId);
    return ApiResponse.success(true, message: 'Task deleted');
  }

  /// Smart Task Suggestions:
  /// Evaluates pending topics across all subjects and scores them based on:
  /// 1. Overdue status (Weight +100)
  /// 2. Approaching deadlines within 3 days (Weight +50)
  /// 3. High priority (+30), Medium (+15)
  Future<List<Map<String, dynamic>>> getSmartSuggestions() async {
    final List<Map<String, dynamic>> suggestions = [];

    for (final subject in _mock.subjects) {
      for (final chapter in subject.chapters) {
        for (final topic in chapter.topics) {
          if (!topic.isCompleted) {
            int urgencyScore = 0;
            String reason = 'Pending Topic';

            if (DateFormatter.isOverdue(topic.targetDate)) {
              urgencyScore += 100;
              reason = '🚨 Overdue target date!';
            } else if (DateFormatter.isApproaching(topic.targetDate)) {
              urgencyScore += 50;
              reason = '⏳ Target deadline approaching';
            }

            if (topic.priority.toLowerCase() == 'high') {
              urgencyScore += 30;
            } else if (topic.priority.toLowerCase() == 'medium') {
              urgencyScore += 15;
            }

            suggestions.add({
              'topic': topic,
              'subjectName': subject.name,
              'chapterName': chapter.name,
              'colorHex': subject.colorHex,
              'score': urgencyScore,
              'reason': reason,
            });
          }
        }
      }
    }

    suggestions.sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    return suggestions;
  }
}
