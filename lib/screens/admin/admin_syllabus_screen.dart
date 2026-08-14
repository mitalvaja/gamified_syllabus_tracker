import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/syllabus_provider.dart';
import '../syllabus/add_edit_dialogs.dart';
import '../syllabus/subject_detail_screen.dart';

class AdminSyllabusScreen extends StatelessWidget {
  const AdminSyllabusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syllabus = Provider.of<SyllabusProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Manage Syllabus Templates 📚'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            tooltip: 'Add Subject',
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddSubjectDialog(
                  onSave: (name, code, desc, colorHex) {
                    syllabus.addSubject(
                      name: name,
                      code: code,
                      description: desc,
                      colorHex: colorHex,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: syllabus.subjects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) {
          final s = syllabus.subjects[i];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(s.colorHex).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.book, color: Color(s.colorHex)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('${s.code} • ${s.chapters.length} Units • ${s.totalTopics} Topics', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => SubjectDetailScreen(subjectId: s.id)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger, size: 20),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (c) => AlertDialog(
                        title: const Text('Delete Subject'),
                        content: Text('Are you sure you want to delete ${s.name}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                            onPressed: () {
                              syllabus.deleteSubject(s.id);
                              Navigator.pop(c);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
