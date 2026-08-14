import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/quiz_provider.dart';
import '../../providers/gamification_provider.dart';
import 'quiz_result_screen.dart';

class QuizPlayScreen extends StatelessWidget {
  const QuizPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context, listen: false);
    final quiz = quizProvider.activeQuiz;
    final question = quizProvider.currentQuestion;

    if (quiz == null || question == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No active quiz loaded')),
      );
    }

    final currentIndex = quizProvider.currentQuestionIndex;
    final totalQuestions = quiz.questions.length;
    final selectedOption = quizProvider.selectedAnswers[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(quiz.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (currentIndex + 1) / totalQuestions,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Question Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentIndex + 1} of $totalQuestions',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.xpGoldLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${quiz.xpReward} XP Reward',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.xpGold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Question Text Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (ctx, optIdx) {
                    final isSelected = selectedOption == optIdx;
                    final optionText = question.options[optIdx];
                    final optionLetter = ['A', 'B', 'C', 'D'][optIdx];

                    return InkWell(
                      onTap: () => quizProvider.selectOption(optIdx),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.cardBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                optionLetter,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                optionText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation Buttons
              Row(
                children: [
                  if (currentIndex > 0) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => quizProvider.previousQuestion(),
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: selectedOption == null
                          ? null
                          : () async {
                              if (quizProvider.isLastQuestion) {
                                final attempt = await quizProvider.submitQuiz(
                                  gamificationProvider: gamification,
                                  context: context,
                                );
                                if (attempt != null && context.mounted) {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (_) => QuizResultScreen(
                                        quiz: quiz,
                                        attempt: attempt,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                quizProvider.nextQuestion();
                              }
                            },
                      child: Text(
                        quizProvider.isLastQuestion ? 'Submit Quiz 🏁' : 'Next Question ➡️',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
