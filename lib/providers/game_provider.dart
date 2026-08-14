import 'package:flutter/foundation.dart';
import '../models/grade_level_model.dart';
import 'gamification_provider.dart';

class GameProvider extends ChangeNotifier {
  GradeCategory _activeGrade = GradeCategory.college;
  final Map<String, int> _highScores = {
    'memory_match': 120,
    'speed_math': 450,
    'word_scramble': 300,
    'code_bug_hunter': 500,
    'boss_battle': 1,
  };

  final Map<String, int> _starsEarned = {
    'memory_match': 3,
    'speed_math': 2,
    'word_scramble': 3,
    'code_bug_hunter': 2,
    'boss_battle': 1,
  };

  GradeCategory get activeGrade => _activeGrade;
  Map<String, int> get highScores => _highScores;
  Map<String, int> get starsEarned => _starsEarned;

  int get totalStars => _starsEarned.values.fold(0, (sum, s) => sum + s);

  void setGradeCategory(GradeCategory category) {
    _activeGrade = category;
    notifyListeners();
  }

  Future<void> recordGameResult({
    required String gameKey,
    required int score,
    required int stars,
    required int xpEarned,
    GamificationProvider? gamificationProvider,
  }) async {
    final currentHigh = _highScores[gameKey] ?? 0;
    if (score > currentHigh) {
      _highScores[gameKey] = score;
    }

    final currentStars = _starsEarned[gameKey] ?? 0;
    if (stars > currentStars) {
      _starsEarned[gameKey] = stars;
    }

    if (gamificationProvider != null) {
      await gamificationProvider.onTopicCompleted(
        priority: 'high',
        subjectName: 'Educational Gaming Arena',
      );
    }

    notifyListeners();
  }
}
