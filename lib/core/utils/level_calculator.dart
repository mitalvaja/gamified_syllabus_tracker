import '../constants/app_constants.dart';

class LevelInfo {
  final int level;
  final String title;
  final int currentXp;
  final int minXp;
  final int maxXp;
  final String icon;
  final double progress; // 0.0 to 1.0

  LevelInfo({
    required this.level,
    required this.title,
    required this.currentXp,
    required this.minXp,
    required this.maxXp,
    required this.icon,
    required this.progress,
  });

  int get xpToNextLevel => (maxXp - currentXp).clamp(0, maxXp);
  int get tierTotalXp => maxXp - minXp;
  int get tierEarnedXp => currentXp - minXp;
}

class LevelCalculator {
  static LevelInfo calculate(int xp) {
    final tiers = AppConstants.levelTiers;
    int safeXp = xp < 0 ? 0 : xp;

    Map<String, dynamic> currentTier = tiers.first;

    for (final tier in tiers) {
      if (safeXp >= tier['minXp'] && (tier['level'] == 6 || safeXp < tier['maxXp'])) {
        currentTier = tier;
        break;
      }
    }

    final int level = currentTier['level'] as int;
    final String title = currentTier['name'] as String;
    final int minXp = currentTier['minXp'] as int;
    final int maxXp = currentTier['maxXp'] as int;
    final String icon = currentTier['icon'] as String;

    double progress = 0.0;
    if (level == 6) {
      progress = 1.0;
    } else {
      final range = maxXp - minXp;
      if (range > 0) {
        progress = ((safeXp - minXp) / range).clamp(0.0, 1.0);
      }
    }

    return LevelInfo(
      level: level,
      title: title,
      currentXp: safeXp,
      minXp: minXp,
      maxXp: maxXp,
      icon: icon,
      progress: progress,
    );
  }
}
