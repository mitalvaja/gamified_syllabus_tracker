import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/topic_model.dart';
import 'mock_data_service.dart';

class SyllabusService {
  final ApiClient _apiClient;
  final MockDataService _mock = MockDataService();

  SyllabusService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ApiResponse<List<SubjectModel>>> getSubjects() async {
    final response = await _apiClient.get<List<SubjectModel>>(
      ApiEndpoints.subjects,
      fromJson: (data) => (data as List).map((i) => SubjectModel.fromJson(i)).toList(),
    );

    if (response.success && response.data != null) {
      return response;
    }

    return ApiResponse.success(_mock.subjects);
  }

  Future<ApiResponse<SubjectModel>> addSubject({
    required String name,
    required String code,
    required String description,
    required int colorHex,
  }) async {
    final response = await _apiClient.post<SubjectModel>(
      ApiEndpoints.subjects,
      body: {
        'name': name,
        'code': code,
        'description': description,
        'color_hex': colorHex,
      },
      fromJson: (data) => SubjectModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final newSubject = SubjectModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      code: code,
      description: description,
      colorHex: colorHex,
      chapters: [],
    );
    _mock.subjects.add(newSubject);
    return ApiResponse.success(newSubject, message: 'Subject added successfully');
  }

  Future<ApiResponse<ChapterModel>> addChapter({
    required int subjectId,
    required String name,
    required String description,
    DateTime? targetDate,
  }) async {
    final response = await _apiClient.post<ChapterModel>(
      ApiEndpoints.chapters,
      body: {
        'subject_id': subjectId,
        'name': name,
        'description': description,
        'target_date': targetDate?.toIso8601String(),
      },
      fromJson: (data) => ChapterModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final newChapter = ChapterModel(
      id: DateTime.now().millisecondsSinceEpoch,
      subjectId: subjectId,
      name: name,
      description: description,
      targetDate: targetDate,
      topics: [],
    );

    final subIdx = _mock.subjects.indexWhere((s) => s.id == subjectId);
    if (subIdx != -1) {
      final updatedChapters = List<ChapterModel>.from(_mock.subjects[subIdx].chapters)..add(newChapter);
      _mock.subjects[subIdx] = _mock.subjects[subIdx].copyWith(chapters: updatedChapters);
    }

    return ApiResponse.success(newChapter, message: 'Chapter created successfully');
  }

  Future<ApiResponse<TopicModel>> addTopic({
    required int chapterId,
    required String name,
    required String description,
    required String priority,
    DateTime? targetDate,
  }) async {
    final response = await _apiClient.post<TopicModel>(
      ApiEndpoints.topics,
      body: {
        'chapter_id': chapterId,
        'name': name,
        'description': description,
        'priority': priority,
        'target_date': targetDate?.toIso8601String(),
      },
      fromJson: (data) => TopicModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final newTopic = TopicModel(
      id: DateTime.now().millisecondsSinceEpoch,
      chapterId: chapterId,
      name: name,
      description: description,
      priority: priority,
      targetDate: targetDate,
      status: 'pending',
    );

    for (int s = 0; s < _mock.subjects.length; s++) {
      final chIdx = _mock.subjects[s].chapters.indexWhere((c) => c.id == chapterId);
      if (chIdx != -1) {
        final currentChapter = _mock.subjects[s].chapters[chIdx];
        final updatedTopics = List<TopicModel>.from(currentChapter.topics)..add(newTopic);
        final updatedChapter = currentChapter.copyWith(topics: updatedTopics);
        final updatedChapters = List<ChapterModel>.from(_mock.subjects[s].chapters);
        updatedChapters[chIdx] = updatedChapter;
        _mock.subjects[s] = _mock.subjects[s].copyWith(chapters: updatedChapters);
        break;
      }
    }

    return ApiResponse.success(newTopic, message: 'Topic added successfully');
  }

  Future<ApiResponse<TopicModel>> toggleTopicCompletion(int topicId, bool isCompleted) async {
    final response = await _apiClient.patch<TopicModel>(
      ApiEndpoints.completeTopic(topicId),
      body: {'is_completed': isCompleted},
      fromJson: (data) => TopicModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    TopicModel? foundTopic;
    for (int s = 0; s < _mock.subjects.length; s++) {
      for (int c = 0; c < _mock.subjects[s].chapters.length; c++) {
        final tIdx = _mock.subjects[s].chapters[c].topics.indexWhere((t) => t.id == topicId);
        if (tIdx != -1) {
          final t = _mock.subjects[s].chapters[c].topics[tIdx];
          final updated = t.copyWith(
            status: isCompleted ? 'completed' : 'pending',
            completedAt: isCompleted ? DateTime.now() : null,
          );
          final updatedTopics = List<TopicModel>.from(_mock.subjects[s].chapters[c].topics);
          updatedTopics[tIdx] = updated;
          final updatedChapters = List<ChapterModel>.from(_mock.subjects[s].chapters);
          updatedChapters[c] = _mock.subjects[s].chapters[c].copyWith(topics: updatedTopics);
          _mock.subjects[s] = _mock.subjects[s].copyWith(chapters: updatedChapters);
          foundTopic = updated;
          break;
        }
      }
      if (foundTopic != null) break;
    }

    if (foundTopic != null) {
      return ApiResponse.success(foundTopic, message: isCompleted ? 'Topic marked completed!' : 'Topic marked pending');
    }
    return ApiResponse.error('Topic not found');
  }

  Future<ApiResponse<bool>> deleteSubject(int subjectId) async {
    final response = await _apiClient.delete<bool>(
      '${ApiEndpoints.subjects}/$subjectId',
      fromJson: (data) => true,
    );
    if (response.success) return response;

    _mock.subjects.removeWhere((s) => s.id == subjectId);
    return ApiResponse.success(true, message: 'Subject deleted');
  }
}
