import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/subject_model.dart';
import '../../models/chapter_model.dart';
import '../../models/topic_model.dart';
import '../../providers/syllabus_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../widgets/priority_chip.dart';
import 'add_edit_dialogs.dart';

class SubjectDetailScreen extends StatelessWidget {
  final int subjectId;

  const SubjectDetailScreen({super.key, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    final syllabus = Provider.of<SyllabusProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context);

    final subject = syllabus.subjects.firstWhere(
      (s) => s.id == subjectId,
      orElse: () => SubjectModel(id: subjectId, name: 'Subject Detail'),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(subject.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Chapter',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddChapterDialog(
                  subjectId: subject.id,
                  onSave: (name, desc, targetDate) {
                    syllabus.addChapter(
                      subjectId: subject.id,
                      name: name,
                      description: desc,
                      targetDate: targetDate,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Banner Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Color(subject.colorHex),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(subject.colorHex).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subject.code.isNotEmpty ? subject.code : 'CORE',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${subject.progressPercentInt}% Completed',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subject.name,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (subject.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      subject.description,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: subject.progressPercentage,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${subject.completedTopics} of ${subject.totalTopics} topics finished',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Chapters & Topics Breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Units & Chapters (${subject.chapters.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Topic'),
                  onPressed: () {
                    if (subject.chapters.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please add a chapter first!')),
                      );
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (ctx) => AddTopicDialog(
                        chapterId: subject.chapters.first.id,
                        onSave: (name, desc, priority, targetDate) {
                          syllabus.addTopic(
                            chapterId: subject.chapters.first.id,
                            name: name,
                            description: desc,
                            priority: priority,
                            targetDate: targetDate,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (subject.chapters.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Center(
                  child: Text('No chapters added yet. Tap "Add Chapter" above to get started.'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: subject.chapters.length,
                itemBuilder: (ctx, cIdx) {
                  final chapter = subject.chapters[cIdx];
                  return _buildChapterExpansion(context, subject, chapter, syllabus, gamification);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChapterExpansion(
    BuildContext context,
    SubjectModel subject,
    ChapterModel chapter,
    SyllabusProvider syllabus,
    GamificationProvider gamification,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: chapter.isCompleted ? AppColors.successLight : AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            chapter.isCompleted ? Icons.check_circle : Icons.folder_open,
            color: chapter.isCompleted ? AppColors.success : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          chapter.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chapter.description.isNotEmpty)
              Text(chapter.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: chapter.progressPercentage,
                      minHeight: 5,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        chapter.isCompleted ? AppColors.success : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${chapter.completedTopics}/${chapter.totalTopics}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.primary),
          tooltip: 'Add Topic to this Chapter',
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AddTopicDialog(
                chapterId: chapter.id,
                onSave: (name, desc, priority, targetDate) {
                  syllabus.addTopic(
                    chapterId: chapter.id,
                    name: name,
                    description: desc,
                    priority: priority,
                    targetDate: targetDate,
                  );
                },
              ),
            );
          },
        ),
        children: [
          if (chapter.topics.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No topics in this chapter yet.', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: chapter.topics.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
              itemBuilder: (ctx, tIdx) {
                final topic = chapter.topics[tIdx];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Checkbox(
                    value: topic.isCompleted,
                    activeColor: AppColors.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    onChanged: (val) async {
                      final targetState = val ?? false;
                      final ok = await syllabus.toggleTopicCompletion(
                        topicId: topic.id,
                        isCompleted: targetState,
                        priority: topic.priority,
                        subjectName: subject.name,
                        gamificationProvider: gamification,
                      );
                      if (ok && targetState && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('🎉 "${topic.name}" completed! +${topic.priority == 'high' ? 20 : 10} XP earned!'),
                            backgroundColor: AppColors.success,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                  title: Text(
                    topic.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      decoration: topic.isCompleted ? TextDecoration.lineThrough : null,
                      color: topic.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (topic.description.isNotEmpty)
                        Text(topic.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            DateFormatter.formatDisplayDate(topic.targetDate),
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PriorityChip(priority: topic.priority),
                );
              },
            ),
        ],
      ),
    );
  }
}
