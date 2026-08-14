import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/quiz_model.dart';
import 'weak_topics_screen.dart';

class QuizResultScreen extends StatelessWidget {
  final QuizModel quiz;
  final QuizAttemptModel attempt;

  const QuizResultScreen({
    super.key,
    required this.quiz,
    required this.attempt,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPerfect = attempt.score == attempt.totalQuestions;
    final bool isPass = attempt.percentage >= 60.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz Performance 🎯'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Result Badge & Celebration Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isPerfect ? AppColors.xpGold : AppColors.cardBorder,
                    width: isPerfect ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isPerfect ? AppColors.xpGold.withOpacity(0.2) : Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      isPerfect
                          ? '🌟 PERFECT SCORE! 🌟'
                          : isPass
                              ? '🎉 EXCELLENT JOB! 🎉'
                              : '💪 GOOD EFFORT! KEEP GOING',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: isPerfect
                            ? AppColors.xpGold
                            : isPass
                                ? AppColors.success
                                : AppColors.warning,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '${attempt.percentage.round()}%',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${attempt.score} out of ${attempt.totalQuestions} questions answered correctly',
                      style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.xpGoldLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bolt, color: AppColors.xpGold, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            '+${attempt.xpEarned} XP Earned!',
                            style: const TextStyle(
                              color: AppColors.xpGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Review answers details
              const Text(
                'Question Breakdown',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quiz.questions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, idx) {
                  final q = quiz.questions[idx];
                  final correctAns = q.options[q.correctOptionIndex];

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q${idx + 1}: ${q.questionText}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 6),
                        Text('Correct Answer: $correctAns', style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                        if (q.explanation.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('💡 ${q.explanation}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Action Buttons
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Return to Quiz Hub 📚', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const WeakTopicsScreen()),
                  );
                },
                child: const Text('View Weak Topics & Revision'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
