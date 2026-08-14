import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/syllabus_provider.dart';
import '../../widgets/circular_progress_widget.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syllabus = Provider.of<SyllabusProvider>(context);

    final allTopics = syllabus.subjects.expand((s) => s.allTopics).toList();
    final completedCount = allTopics.where((t) => t.isCompleted).length;
    final pendingCount = allTopics.where((t) => !t.isCompleted).length;
    final overdueCount = allTopics.where((t) => DateFormatter.isOverdue(t.targetDate, isCompleted: t.isCompleted)).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Curriculum Progress & Analytics 📊'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Gauge Card
            CircularProgressCard(
              title: 'Overall Syllabus Mastery',
              percentage: syllabus.overallProgress,
              centerText: '${syllabus.overallProgressPercent}%',
              subtitle: '$completedCount of ${syllabus.totalSyllabusTopics} syllabus milestones completed.',
              progressColor: AppColors.primary,
            ),
            const SizedBox(height: 18),

            // 3-Metric Summary Bar
            Row(
              children: [
                Expanded(
                  child: _buildMetricBadge(
                    title: 'Completed',
                    count: completedCount,
                    color: AppColors.success,
                    bg: AppColors.successLight,
                    icon: Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricBadge(
                    title: 'Pending',
                    count: pendingCount,
                    color: AppColors.info,
                    bg: AppColors.infoLight,
                    icon: Icons.pending_actions,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricBadge(
                    title: 'Overdue',
                    count: overdueCount,
                    color: AppColors.danger,
                    bg: AppColors.dangerLight,
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Subject-wise Breakdown
            const Text(
              'Subject-wise Progress Breakdown 📖',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            if (syllabus.subjects.isEmpty)
              const Center(child: Text('No subjects to display'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: syllabus.subjects.length,
                itemBuilder: (ctx, idx) {
                  final subject = syllabus.subjects[idx];
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              subject.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${subject.progressPercentInt}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(subject.colorHex),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${subject.completedTopics} of ${subject.totalTopics} topics completed',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: subject.progressPercentage,
                            minHeight: 10,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation<Color>(Color(subject.colorHex)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: subject.chapters.map((c) {
                            return Chip(
                              backgroundColor: c.isCompleted ? AppColors.successLight : AppColors.surfaceVariant,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                              label: Text(
                                '${c.name.split(':').first} (${c.completedTopics}/${c.totalTopics})',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: c.isCompleted ? AppColors.success : AppColors.textSecondary,
                                ),
                              ),
                            );
                          }).toList(),
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

  Widget _buildMetricBadge({
    required String title,
    required int count,
    required Color color,
    required Color bg,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
