import 'package:flutter/foundation.dart';
import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/topic_model.dart';
import '../services/syllabus_service.dart';
import 'gamification_provider.dart';

class SyllabusProvider extends ChangeNotifier {
  final SyllabusService _service;

  List<SubjectModel> _subjects = [];
  bool _isLoading = false;
  String? _errorMessage;

  SyllabusProvider({SyllabusService? service}) : _service = service ?? SyllabusService();

  List<SubjectModel> get subjects => _subjects;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalSyllabusTopics => _subjects.fold(0, (sum, s) => sum + s.totalTopics);
  int get completedSyllabusTopics => _subjects.fold(0, (sum, s) => sum + s.completedTopics);
  double get overallProgress => totalSyllabusTopics == 0 ? 0.0 : (completedSyllabusTopics / totalSyllabusTopics);
  int get overallProgressPercent => (overallProgress * 100).round();

  Future<void> fetchSubjects() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final res = await _service.getSubjects();
    if (res.success && res.data != null) {
      _subjects = res.data!;
    } else {
      _errorMessage = res.message;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addSubject({
    required String name,
    required String code,
    required String description,
    required int colorHex,
  }) async {
    final res = await _service.addSubject(
      name: name,
      code: code,
      description: description,
      colorHex: colorHex,
    );
    if (res.success) {
      await fetchSubjects();
      return true;
    }
    return false;
  }

  Future<bool> addChapter({
    required int subjectId,
    required String name,
    required String description,
    DateTime? targetDate,
  }) async {
    final res = await _service.addChapter(
      subjectId: subjectId,
      name: name,
      description: description,
      targetDate: targetDate,
    );
    if (res.success) {
      await fetchSubjects();
      return true;
    }
    return false;
  }

  Future<bool> addTopic({
    required int chapterId,
    required String name,
    required String description,
    required String priority,
    DateTime? targetDate,
  }) async {
    final res = await _service.addTopic(
      chapterId: chapterId,
      name: name,
      description: description,
      priority: priority,
      targetDate: targetDate,
    );
    if (res.success) {
      await fetchSubjects();
      return true;
    }
    return false;
  }

  Future<bool> toggleTopicCompletion({
    required int topicId,
    required bool isCompleted,
    required String priority,
    required String subjectName,
    GamificationProvider? gamificationProvider,
  }) async {
    final res = await _service.toggleTopicCompletion(topicId, isCompleted);
    if (res.success) {
      if (isCompleted && gamificationProvider != null) {
        await gamificationProvider.onTopicCompleted(
          priority: priority,
          subjectName: subjectName,
        );
      }
      await fetchSubjects();
      return true;
    }
    return false;
  }

  Future<bool> deleteSubject(int subjectId) async {
    final res = await _service.deleteSubject(subjectId);
    if (res.success) {
      _subjects.removeWhere((s) => s.id == subjectId);
      notifyListeners();
      return true;
    }
    return false;
  }
}
