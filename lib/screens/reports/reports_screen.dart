import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/report_provider.dart';
import '../../providers/syllabus_provider.dart';
import '../../widgets/stat_card.dart';
import 'export_report_dialog.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedTab = 0; // 0 = Weekly, 1 = Monthly

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).fetchReports();
    });
  }

  void _openExportDialog() {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => ExportReportDialog(
        onExport: (format) => reportProvider.exportReport(format),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final syllabus = Provider.of<SyllabusProvider>(context);
    final weekly = reportProvider.weeklyReport;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performance & Reports 📈'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
            tooltip: 'Export Report',
            onPressed: _openExportDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period toggle
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Weekly Report')),
                      selected: _selectedTab == 0,
                      onSelected: (val) => setState(() => _selectedTab = 0),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Monthly Overview')),
                      selected: _selectedTab == 1,
                      onSelected: (val) => setState(() => _selectedTab = 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Performance Cards Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.45,
              children: [
                StatCard(
                  title: 'Topics Finished',
                  value: '${weekly?.topicsCompleted ?? 0}',
                  subtitle: 'This cycle',
                  icon: Icons.checklist_rtl_rounded,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'Total Study Time',
                  value: '${((weekly?.totalStudyMinutes ?? 0) / 60).toStringAsFixed(1)} hrs',
                  subtitle: '${weekly?.totalStudyMinutes ?? 0} mins',
                  icon: Icons.timer,
                  color: AppColors.secondary,
                ),
                StatCard(
                  title: 'XP Earned',
                  value: '+${weekly?.xpEarned ?? 0} XP',
                  subtitle: 'Milestones',
                  icon: Icons.stars,
                  color: AppColors.xpGold,
                ),
                StatCard(
                  title: 'Quiz Average',
                  value: '${weekly?.averageQuizScore.round() ?? 0}%',
                  subtitle: 'Accuracy',
                  icon: Icons.quiz,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly Velocity Activity Chart
            const Text(
              'Weekly Study Velocity 📊',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Topics Mastered / Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Target: 2 topics/day', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar('Mon', weekly?.dailyCompletedTopics[0] ?? 1, 3),
                      _buildBar('Tue', weekly?.dailyCompletedTopics[1] ?? 0, 3),
                      _buildBar('Wed', weekly?.dailyCompletedTopics[2] ?? 2, 3),
                      _buildBar('Thu', weekly?.dailyCompletedTopics[3] ?? 1, 3),
                      _buildBar('Fri', weekly?.dailyCompletedTopics[4] ?? 3, 3),
                      _buildBar('Sat', weekly?.dailyCompletedTopics[5] ?? 2, 3),
                      _buildBar('Sun', weekly?.dailyCompletedTopics[6] ?? 1, 3),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Subject Distribution
            const Text(
              'Subject Time Allocation ⏱️',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),

            if (weekly?.subjectMinutes != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: weekly!.subjectMinutes.entries.map((entry) {
                    final percent = (entry.value / (weekly.totalStudyMinutes > 0 ? weekly.totalStudyMinutes : 1)).clamp(0.0, 1.0);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text('${entry.value} mins (${(percent * 100).round()}%)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: percent,
                              minHeight: 6,
                              backgroundColor: AppColors.surfaceVariant,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),

            // Export CTA Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.picture_as_pdf, color: Colors.white, size: 36),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Export Official Report', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        Text('Share progress with mentors & faculty', style: TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: _openExportDialog,
                    child: const Text('Export', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String day, int count, int max) {
    final double fraction = (count / max).clamp(0.1, 1.0);
    return Column(
      children: [
        Text('$count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 80 * fraction,
          decoration: BoxDecoration(
            color: count > 0 ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
