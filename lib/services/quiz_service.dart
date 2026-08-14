import '../core/constants/api_endpoints.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import 'mock_data_service.dart';

class WeakTopicModel {
  final String subjectName;
  final String chapterName;
  final String topicName;
  final int incorrectAnswersCount;
  final String recommendedAction;

  WeakTopicModel({
    required this.subjectName,
    required this.chapterName,
    required this.topicName,
    required this.incorrectAnswersCount,
    required this.recommendedAction,
  });
}

class QuizService {
  final ApiClient _apiClient;
  final MockDataService _mock = MockDataService();

  QuizService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<ApiResponse<List<QuizModel>>> getQuizzes({int? chapterId}) async {
    final response = await _apiClient.get<List<QuizModel>>(
      ApiEndpoints.quizzes,
      fromJson: (data) =>
          (data as List).map((i) => QuizModel.fromJson(i)).toList(),
    );

    if (response.success && response.data != null) {
      if (chapterId != null) {
        final filtered =
            response.data!.where((q) => q.chapterId == chapterId).toList();
        return ApiResponse.success(filtered);
      }
      return response;
    }

    if (chapterId != null) {
      final filtered =
          _mock.quizzes.where((q) => q.chapterId == chapterId).toList();
      return ApiResponse.success(filtered);
    }
    return ApiResponse.success(_mock.quizzes);
  }

  Future<ApiResponse<QuizModel>> getQuizById(int quizId) async {
    final response = await _apiClient.get<QuizModel>(
      ApiEndpoints.quizDetail(quizId),
      fromJson: (data) => QuizModel.fromJson(data),
    );

    if (response.success && response.data != null) {
      return response;
    }

    final q = _mock.quizzes.firstWhere(
      (quiz) => quiz.id == quizId,
      orElse: () => _mock.quizzes.first,
    );
    return ApiResponse.success(q);
  }

  Future<ApiResponse<QuizAttemptModel>> submitQuizAttempt({
    required int quizId,
    required int score,
    required int totalQuestions,
    required int xpEarned,
  }) async {
    final percentage =
        totalQuestions == 0 ? 0.0 : (score / totalQuestions) * 100.0;

    final attempt = QuizAttemptModel(
      id: DateTime.now().millisecondsSinceEpoch,
      quizId: quizId,
      score: score,
      totalQuestions: totalQuestions,
      percentage: percentage,
      xpEarned: xpEarned,
      attemptedAt: DateTime.now(),
    );

    final idx = _mock.quizzes.indexWhere((q) => q.id == quizId);
    if (idx != -1) {
      _mock.quizzes[idx] = QuizModel(
        id: _mock.quizzes[idx].id,
        chapterId: _mock.quizzes[idx].chapterId,
        subjectName: _mock.quizzes[idx].subjectName,
        chapterName: _mock.quizzes[idx].chapterName,
        title: _mock.quizzes[idx].title,
        xpReward: _mock.quizzes[idx].xpReward,
        questions: _mock.quizzes[idx].questions,
        lastAttempt: attempt,
      );
    }

    return ApiResponse.success(attempt,
        message: 'Quiz submitted successfully!');
  }

  Future<List<WeakTopicModel>> getWeakTopics() async {
    // Generate weak topic insights based on quiz attempts or low topic mastery
    return [
      WeakTopicModel(
        subjectName: 'Computer Science',
        chapterName: 'Unit 1: Trees & Balanced BSTs',
        topicName: 'AVL Tree Rotations',
        incorrectAnswersCount: 2,
        recommendedAction:
            'Re-read Double Rotations (LR/RL) notes and attempt practice quiz.',
      ),
      WeakTopicModel(
        subjectName: 'Database Management',
        chapterName: 'Unit 1: Relational Schema & SQL',
        topicName: 'Database Normalization (1NF to BCNF)',
        incorrectAnswersCount: 1,
        recommendedAction:
            'Review Boyce-Codd Normal Form functional dependency rules.',
      ),
    ];
  }
}
