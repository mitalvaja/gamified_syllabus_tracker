import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quiz_model.dart';
import '../../providers/quiz_provider.dart';
import 'quiz_play_screen.dart';
import 'weak_topics_screen.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).fetchQuizzes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chapter-wise Quizzes 🧠'),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology_alt_outlined, color: AppColors.primary),
            tooltip: 'Weak Topics Revision',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WeakTopicsScreen()),
              );
            },
          ),
        ],
      ),
      body: quizProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => quizProvider.fetchQuizzes(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner card promoting quiz XP and Weak topics
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Test Your Knowledge',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Earn +15 to +25 XP for each completed quiz, identify weak topics, and prepare for exams!',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primaryDark,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.bolt, color: AppColors.xpGold, size: 18),
                                  label: const Text('Weak Topics Guide', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const WeakTopicsScreen()),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('🎯', style: TextStyle(fontSize: 48)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Available Quizzes
                    const Text(
                      'Available Chapter Quizzes',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),

                    if (quizProvider.quizzes.isEmpty)
                      const Center(child: Text('No quizzes created yet.'))
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: quizProvider.quizzes.length,
                        itemBuilder: (ctx, i) {
                          final quiz = quizProvider.quizzes[i];
                          return _buildQuizCard(context, quiz, quizProvider);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuizCard(BuildContext context, QuizModel quiz, QuizProvider provider) {
    final hasAttempt = quiz.isAttempted;
    final lastScore = quiz.lastAttempt?.percentage.round();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.quiz, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      '${quiz.subjectName} • ${quiz.chapterName}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.xpGoldLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+${quiz.xpReward} XP',
                  style: const TextStyle(color: AppColors.xpGold, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${quiz.questions.length} Questions • ~5 mins',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
              if (hasAttempt)
                Text(
                  'Best Score: $lastScore% 🎉',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.success),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: hasAttempt ? AppColors.surfaceVariant : AppColors.primary,
                foregroundColor: hasAttempt ? AppColors.textPrimary : Colors.white,
              ),
              onPressed: () {
                provider.startQuiz(quiz);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const QuizPlayScreen()),
                );
              },
              child: Text(
                hasAttempt ? 'Retake Quiz 🔄' : 'Start Quiz 🚀',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
