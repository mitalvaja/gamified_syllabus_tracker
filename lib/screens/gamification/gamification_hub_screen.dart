import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/gamification_provider.dart';
import '../../widgets/level_progress_banner.dart';
import '../../widgets/streak_counter_badge.dart';
import 'badge_gallery_screen.dart';
import 'leaderboard_screen.dart';

class GamificationHubScreen extends StatelessWidget {
  const GamificationHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamification = Provider.of<GamificationProvider>(context);
    final levelInfo = gamification.levelInfo;
    final streak = gamification.streak;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gamification & Rewards 🎮'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Progression Card
            LevelProgressBanner(levelInfo: levelInfo),
            const SizedBox(height: 18),

            // Streak Showcase Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.streakFlame.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${streak?.currentStreak ?? 0} Day Active Streak',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.streakFlame,
                                ),
                              ),
                              Text(
                                'Personal Best: ${streak?.longestStreak ?? 0} days',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                      StreakCounterBadge(streakDays: streak?.currentStreak ?? 0),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    streak?.motivationalMessage ?? 'Keep studying daily to maintain your fire!',
                    style: const TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Hub Nav Cards (Badges & Leaderboard)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BadgeGalleryScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 8),
                          const Text('Badge Gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(
                            '${gamification.unlockedBadgesCount}/${gamification.badges.length} Unlocked',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🥇', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 8),
                          const Text('Class Ranking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const Text('BCA Sem V Leaderboard', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Level Progression Road (1 to 6)
            const Text(
              'Academic Level Road 🗺️',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: AppConstants.levelTiers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, idx) {
                final tier = AppConstants.levelTiers[idx];
                final int lvl = tier['level'];
                final bool isCurrent = lvl == levelInfo.level;
                final bool isPassed = lvl < levelInfo.level;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? AppColors.primaryLight
                        : isPassed
                            ? AppColors.surface
                            : AppColors.surfaceVariant.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isCurrent
                          ? AppColors.primary
                          : isPassed
                              ? AppColors.success.withOpacity(0.3)
                              : AppColors.cardBorder,
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(tier['icon'], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Level $lvl — ${tier['name']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              lvl == 6 ? '1500+ XP required' : '${tier['minXp']} - ${tier['maxXp']} XP required',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      if (isPassed)
                        const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                      else if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('CURRENT', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      else
                        const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
