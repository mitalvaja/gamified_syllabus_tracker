import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/gamification_provider.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gamification = Provider.of<GamificationProvider>(context);
    final list = gamification.leaderboard;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('BCA Class Leaderboard 🏆'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // Podium for Top 3 Students
            if (list.length >= 3) _buildPodium(list.take(3).toList()),
            const SizedBox(height: 24),

            // Complete Ranking List
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Class Standings (Sem V)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 10),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final student = list[i];
                final isMe = student.name.contains('You');

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.primaryLight : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isMe ? AppColors.primary : AppColors.cardBorder,
                      width: isMe ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Rank number or medal
                      SizedBox(
                        width: 30,
                        child: Text(
                          student.rank == 1
                              ? '🥇'
                              : student.rank == 2
                                  ? '🥈'
                                  : student.rank == 3
                                      ? '🥉'
                                      : '#${student.rank}',
                          style: TextStyle(
                            fontSize: student.rank <= 3 ? 20 : 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        child: Text(
                          student.name.substring(0, 1),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Name & Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isMe ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${student.className} • Level ${student.level}',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      // XP and Badges
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${student.totalXp} XP',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold, fontSize: 14),
                          ),
                          Text(
                            '${student.badgesCount} Badges',
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
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

  Widget _buildPodium(List<dynamic> top3) {
    final first = top3[0];
    final second = top3[1];
    final third = top3[2];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF312E81), Color(0xFF4338CA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          _buildPodiumPillar(
            student: second,
            place: '2nd',
            medal: '🥈',
            height: 90,
            color: const Color(0xFF94A3B8),
          ),
          // 1st Place (Center / Highest)
          _buildPodiumPillar(
            student: first,
            place: '1st',
            medal: '👑',
            height: 120,
            color: AppColors.xpGold,
            isWinner: true,
          ),
          // 3rd Place
          _buildPodiumPillar(
            student: third,
            place: '3rd',
            medal: '🥉',
            height: 75,
            color: const Color(0xFFCD7F32),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumPillar({
    required dynamic student,
    required String place,
    required String medal,
    required double height,
    required Color color,
    bool isWinner = false,
  }) {
    return Column(
      children: [
        Text(medal, style: TextStyle(fontSize: isWinner ? 28 : 22)),
        const SizedBox(height: 4),
        Text(
          student.name.split(' ').first,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          '${student.totalXp} XP',
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
        const SizedBox(height: 8),
        Container(
          width: 76,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: color.withOpacity(0.6), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            place,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
