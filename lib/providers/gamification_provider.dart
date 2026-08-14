import 'package:flutter/material.dart';
import '../core/utils/level_calculator.dart';
import '../models/badge_model.dart';
import '../models/streak_model.dart';
import '../models/analytics_model.dart';
import '../services/gamification_service.dart';
import '../services/mock_data_service.dart';
import '../widgets/level_up_dialog.dart';
import 'auth_provider.dart';

class GamificationProvider extends ChangeNotifier {
  final GamificationService _service;
  final MockDataService _mock = MockDataService();

  StreakModel? _streak;
  List<BadgeModel> _badges = [];
  List<LeaderboardEntryModel> _leaderboard = [];
  LevelInfo _levelInfo = LevelCalculator.calculate(340);
  bool _isLoading = false;

  GamificationRewardResult? _latestReward;

  GamificationProvider({GamificationService? service}) : _service = service ?? GamificationService() {
    refreshGamificationData();
  }

  StreakModel? get streak => _streak;
  List<BadgeModel> get badges => _badges;
  List<LeaderboardEntryModel> get leaderboard => _leaderboard;
  LevelInfo get levelInfo => _levelInfo;
  bool get isLoading => _isLoading;
  GamificationRewardResult? get latestReward => _latestReward;

  int get unlockedBadgesCount => _badges.where((b) => b.isUnlocked).length;

  Future<void> refreshGamificationData() async {
    _isLoading = true;
    notifyListeners();

    _streak = await _service.getStreak();
    _badges = await _service.getBadges();
    _leaderboard = await _service.getLeaderboard();
    _levelInfo = LevelCalculator.calculate(_mock.currentUser.totalXp);

    _isLoading = false;
    notifyListeners();
  }

  Future<GamificationRewardResult> onTopicCompleted({
    required String priority,
    required String subjectName,
    BuildContext? context,
    AuthProvider? authProvider,
  }) async {
    final result = await _service.awardTopicCompletion(
      priority: priority,
      subjectName: subjectName,
    );

    _latestReward = result;
    _levelInfo = result.newLevelInfo;
    if (authProvider != null) {
      authProvider.syncUserFromGamification(_mock.currentUser);
    }
    await refreshGamificationData();

    if (result.leveledUp && context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => LevelUpDialog(levelInfo: result.newLevelInfo),
      );
    }

    return result;
  }

  Future<GamificationRewardResult> onQuizCompleted({
    required int score,
    required int totalQuestions,
    BuildContext? context,
    AuthProvider? authProvider,
  }) async {
    final result = await _service.awardQuizCompletion(
      score: score,
      totalQuestions: totalQuestions,
    );

    _latestReward = result;
    _levelInfo = result.newLevelInfo;
    if (authProvider != null) {
      authProvider.syncUserFromGamification(_mock.currentUser);
    }
    await refreshGamificationData();

    if (result.leveledUp && context != null && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => LevelUpDialog(levelInfo: result.newLevelInfo),
      );
    }

    return result;
  }
}
