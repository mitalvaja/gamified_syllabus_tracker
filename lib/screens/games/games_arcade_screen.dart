import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/grade_level_model.dart';
import '../../providers/game_provider.dart';
import 'memory_match_game.dart';
import 'speed_math_game.dart';
import 'word_scramble_game.dart';
import 'code_bug_hunter_game.dart';
import 'boss_battle_game.dart';

class GamesArcadeScreen extends StatelessWidget {
  const GamesArcadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final activeGrade = gameProvider.activeGrade;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Educational Games Arcade 🎮'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.xpGoldLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text(
                  '${gameProvider.totalStars} Stars',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.xpGold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grade Selector Header
            const Text(
              'Select Your Learning Tier / Age Group 🎯',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            // 3 Grade Level Selector Cards
            Row(
              children: GradeLevelModel.supportedGrades.map((g) {
                final isSelected = g.category == activeGrade;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => gameProvider.setGradeCategory(g.category),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.cardBorder,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Text(g.icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(
                            g.title.split(' ')[0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            g.category == GradeCategory.junior ? 'Nursery-G5' : g.category == GradeCategory.highSchool ? 'G6-G10' : 'College',
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white70 : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Grade Overview Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Text(
                    activeGrade == GradeCategory.junior ? '🎨' : activeGrade == GradeCategory.highSchool ? '🚀' : '🎓',
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeGrade == GradeCategory.junior
                              ? 'Junior Mode (Ages 3-10)'
                              : activeGrade == GradeCategory.highSchool
                                  ? 'High School Mode (Ages 11-16)'
                                  : 'College & University Mode (Ages 17+)',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeGrade == GradeCategory.junior
                              ? 'Interactive games adapted for alphabet, counting, animals, & phonics.'
                              : activeGrade == GradeCategory.highSchool
                                  ? 'Games adapted for science formulas, speed math, & vocabulary.'
                                  : 'Games adapted for DSA, DBMS, Mathematics, Flutter & algorithms.',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Playable Learning Mini-Games 🕹️',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            // Game 1: Memory Match
            _buildGameCard(
              context: context,
              icon: '🃏',
              title: 'Memory Match & Concept Flip',
              subtitle: activeGrade == GradeCategory.junior
                  ? 'Match letters with animals and numbers with dots!'
                  : 'Match concepts with definitions & complexities!',
              stars: gameProvider.starsEarned['memory_match'] ?? 0,
              highScore: gameProvider.highScores['memory_match'] ?? 0,
              xpReward: '+30 XP',
              gradientColors: [const Color(0xFF4F46E5), const Color(0xFF6366F1)],
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MemoryMatchGameScreen(gradeCategory: activeGrade)),
              ),
            ),

            // Game 2: Speed Math
            _buildGameCard(
              context: context,
              icon: '⚡',
              title: 'Speed Math Lightning',
              subtitle: activeGrade == GradeCategory.junior
                  ? 'Fast addition and subtraction balloon fun!'
                  : 'Fast-paced mental math & matrix arithmetic!',
              stars: gameProvider.starsEarned['speed_math'] ?? 0,
              highScore: gameProvider.highScores['speed_math'] ?? 0,
              xpReward: '+35 XP',
              gradientColors: [const Color(0xFF0EA5E9), const Color(0xFF38BDF8)],
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SpeedMathGameScreen(gradeCategory: activeGrade)),
              ),
            ),

            // Game 3: Word Scramble
            _buildGameCard(
              context: context,
              icon: '🔤',
              title: 'Word & Terminology Scramble',
              subtitle: activeGrade == GradeCategory.junior
                  ? 'Spell fruit and animal names letter by letter!'
                  : 'Unscramble academic keywords from syllabus clues!',
              stars: gameProvider.starsEarned['word_scramble'] ?? 0,
              highScore: gameProvider.highScores['word_scramble'] ?? 0,
              xpReward: '+30 XP',
              gradientColors: [const Color(0xFF10B981), const Color(0xFF34D399)],
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WordScrambleGameScreen(gradeCategory: activeGrade)),
              ),
            ),

            // Game 4: Code Bug Hunter (Unlocked for High School & College)
            if (activeGrade != GradeCategory.junior)
              _buildGameCard(
                context: context,
                icon: '🐛',
                title: 'Code Bug Hunter & Logic Quest',
                subtitle: 'Find and squash syntax bugs in Dart, SQL, Python, and DSA!',
                stars: gameProvider.starsEarned['code_bug_hunter'] ?? 0,
                highScore: gameProvider.highScores['code_bug_hunter'] ?? 0,
                xpReward: '+40 XP',
                gradientColors: [const Color(0xFFF97316), const Color(0xFFFB923C)],
                onPlay: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CodeBugHunterGameScreen(gradeCategory: activeGrade)),
                ),
              ),

            // Game 5: Syllabus Boss Battle
            _buildGameCard(
              context: context,
              icon: '⚔️',
              title: 'Syllabus Boss Battle (RPG Rush)',
              subtitle: 'Defeat the Semester Exam Boss by answering syllabus questions!',
              stars: gameProvider.starsEarned['boss_battle'] ?? 0,
              highScore: gameProvider.highScores['boss_battle'] ?? 0,
              xpReward: '+100 XP',
              gradientColors: [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
              onPlay: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BossBattleGameScreen(gradeCategory: activeGrade)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required int stars,
    required int highScore,
    required String xpReward,
    required List<Color> gradientColors,
    required VoidCallback onPlay,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: Text(icon, style: const TextStyle(fontSize: 26)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.xpGoldLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              xpReward,
                              style: const TextStyle(color: AppColors.xpGold, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            stars == 0 ? '☆☆☆' : '⭐⭐⭐'.substring(0, stars),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          Text('High Score: $highScore', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: onPlay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gradientColors[0],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Play Game 🚀', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
