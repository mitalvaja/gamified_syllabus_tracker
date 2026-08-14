import '../core/constants/app_constants.dart';
import '../core/network/api_client.dart';
import '../core/network/api_response.dart';
import '../core/utils/level_calculator.dart';
import '../models/badge_model.dart';
import '../models/streak_model.dart';
import '../models/analytics_model.dart';
import 'mock_data_service.dart';

class GamificationRewardResult {
  final int addedXp;
  final int newTotalXp;
  final bool leveledUp;
  final LevelInfo newLevelInfo;
  final List<BadgeModel> newlyUnlockedBadges;
  final int streakDays;

  GamificationRewardResult({
    required this.addedXp,
    required this.newTotalXp,
    required this.leveledUp,
    required this.newLevelInfo,
    required this.newlyUnlockedBadges,
    required this.streakDays,
  });
}

class GamificationService {
  final ApiClient _apiClient;
  final MockDataService _mock = MockDataService();

  GamificationService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<StreakModel> getStreak() async {
    return _mock.userStreak;
  }

  Future<List<BadgeModel>> getBadges() async {
    return _mock.badges;
  }

  Future<List<LeaderboardEntryModel>> getLeaderboard() async {
    return _mock.leaderboard;
  }

  /// Process Gamification Rewards for completing a topic
  Future<GamificationRewardResult> awardTopicCompletion({
    required String priority,
    required String subjectName,
  }) async {
    int earnedXp = AppConstants.xpPerTopicCompletion;
    if (priority.toLowerCase() == 'high') {
      earnedXp += 10; // Extra bonus for high priority
    }

    return _applyGamificationChanges(
      xpReward: earnedXp,
      actionType: 'topic',
      subjectName: subjectName,
    );
  }

  /// Process Gamification Rewards for completing a quiz
  Future<GamificationRewardResult> awardQuizCompletion({
    required int score,
    required int totalQuestions,
  }) async {
    int earnedXp = AppConstants.xpPerQuizCompletion;
    if (score == totalQuestions && totalQuestions > 0) {
      earnedXp += 10; // Perfect score bonus = 25 XP
    }

    return _applyGamificationChanges(
      xpReward: earnedXp,
      actionType: 'quiz',
      isPerfectScore: score == totalQuestions,
    );
  }

  Future<GamificationRewardResult> _applyGamificationChanges({
    required int xpReward,
    required String actionType,
    String? subjectName,
    bool isPerfectScore = false,
  }) async {
    final oldLevel = _mock.currentUser.currentLevel;
    final newTotalXp = _mock.currentUser.totalXp + xpReward;

    // 1. Update Streak (Ensure single daily credit)
    final now = DateTime.now();
    int currentStreak = _mock.userStreak.currentStreak;
    int longestStreak = _mock.userStreak.longestStreak;
    final lastActivity = _mock.userStreak.lastActivityDate;

    if (lastActivity == null) {
      currentStreak = 1;
    } else {
      final isToday = lastActivity.year == now.year &&
          lastActivity.month == now.month &&
          lastActivity.day == now.day;
      final isYesterday = lastActivity.year == now.year &&
          lastActivity.month == now.month &&
          lastActivity.day == (now.day - 1);

      if (!isToday) {
        if (isYesterday) {
          currentStreak += 1;
        } else {
          currentStreak = 1; // Streak reset
        }
      }
    }

    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }

    _mock.userStreak = _mock.userStreak.copyWith(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastActivityDate: now,
    );

    // 2. Check Level Progression
    final newLevelInfo = LevelCalculator.calculate(newTotalXp);
    final bool didLevelUp = newLevelInfo.level > oldLevel;

    // 3. Check Badge Unlocks
    List<BadgeModel> newlyUnlocked = [];

    // Badge: First Step
    _checkAndUnlock('first_step', newlyUnlocked);

    // Badge: 3-Day Streak
    if (currentStreak >= 3) {
      _checkAndUnlock('streak_3', newlyUnlocked);
    }

    // Badge: 7-Day Streak
    if (currentStreak >= 7) {
      _checkAndUnlock('streak_7', newlyUnlocked);
    }

    // Badge: Perfect Score
    if (isPerfectScore) {
      _checkAndUnlock('perfect_score', newlyUnlocked);
    }

    // Badge: Math Master
    if (subjectName != null && subjectName.toLowerCase().contains('math')) {
      final mathSub = _mock.subjects.firstWhere(
        (s) => s.name.toLowerCase().contains('math'),
        orElse: () => _mock.subjects.first,
      );
      if (mathSub.progressPercentage >= 1.0) {
        _checkAndUnlock('math_master', newlyUnlocked);
      }
    }

    // Badge: Scholar
    if (newTotalXp >= 900) {
      _checkAndUnlock('scholar_tier', newlyUnlocked);
    }

    // Update Mock user state
    _mock.currentUser = _mock.currentUser.copyWith(
      totalXp: newTotalXp,
      currentLevel: newLevelInfo.level,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      badgesEarned: _mock.badges.where((b) => b.isUnlocked).length,
    );

    return GamificationRewardResult(
      addedXp: xpReward,
      newTotalXp: newTotalXp,
      leveledUp: didLevelUp,
      newLevelInfo: newLevelInfo,
      newlyUnlockedBadges: newlyUnlocked,
      streakDays: currentStreak,
    );
  }

  void _checkAndUnlock(String code, List<BadgeModel> newlyUnlockedList) {
    final idx = _mock.badges.indexWhere((b) => b.code == code);
    if (idx != -1 && !_mock.badges[idx].isUnlocked) {
      final updated = _mock.badges[idx].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
        currentProgress: _mock.badges[idx].requiredCount,
      );
      _mock.badges[idx] = updated;
      newlyUnlockedList.add(updated);
    }
  }
}
