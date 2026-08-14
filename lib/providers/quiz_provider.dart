import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../services/quiz_service.dart';
import 'gamification_provider.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService _service;

  List<QuizModel> _quizzes = [];
  QuizModel? _activeQuiz;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  bool _isLoading = false;
  List<WeakTopicModel> _weakTopics = [];

  QuizProvider({QuizService? service}) : _service = service ?? QuizService();

  List<QuizModel> get quizzes => _quizzes;
  QuizModel? get activeQuiz => _activeQuiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, int> get selectedAnswers => _selectedAnswers;
  bool get isLoading => _isLoading;
  List<WeakTopicModel> get weakTopics => _weakTopics;

  QuestionModel? get currentQuestion {
    if (_activeQuiz == null ||
        _activeQuiz!.questions.isEmpty ||
        _currentQuestionIndex >= _activeQuiz!.questions.length) {
      return null;
    }
    return _activeQuiz!.questions[_currentQuestionIndex];
  }

  bool get isLastQuestion {
    if (_activeQuiz == null) return false;
    return _currentQuestionIndex == _activeQuiz!.questions.length - 1;
  }

  Future<void> fetchQuizzes() async {
    _isLoading = true;
    notifyListeners();

    final res = await _service.getQuizzes();
    if (res.success && res.data != null) {
      _quizzes = res.data!;
    }
    _weakTopics = await _service.getWeakTopics();

    _isLoading = false;
    notifyListeners();
  }

  void startQuiz(QuizModel quiz) {
    _activeQuiz = quiz;
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    notifyListeners();
  }

  void selectOption(int optionIndex) {
    _selectedAnswers[_currentQuestionIndex] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (!isLastQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  Future<QuizAttemptModel?> submitQuiz({
    GamificationProvider? gamificationProvider,
    BuildContext? context,
  }) async {
    if (_activeQuiz == null) return null;

    int correctCount = 0;
    final total = _activeQuiz!.questions.length;

    for (int i = 0; i < total; i++) {
      final q = _activeQuiz!.questions[i];
      final chosen = _selectedAnswers[i];
      if (chosen != null && chosen == q.correctOptionIndex) {
        correctCount++;
      }
    }

    int xpEarned = _activeQuiz!.xpReward;
    if (correctCount == total && total > 0) {
      xpEarned += 10; // Perfect score bonus
    }

    final res = await _service.submitQuizAttempt(
      quizId: _activeQuiz!.id,
      score: correctCount,
      totalQuestions: total,
      xpEarned: xpEarned,
    );

    if (gamificationProvider != null) {
      await gamificationProvider.onQuizCompleted(
        score: correctCount,
        totalQuestions: total,
        context: context,
      );
    }

    await fetchQuizzes();
    return res.data;
  }
}
