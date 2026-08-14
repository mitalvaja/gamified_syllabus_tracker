import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/custom_text_field.dart';

class AdminAnnouncementsScreen extends StatefulWidget {
  const AdminAnnouncementsScreen({super.key});

  @override
  State<AdminAnnouncementsScreen> createState() => _AdminAnnouncementsScreenState();
}

class _AdminAnnouncementsScreenState extends State<AdminAnnouncementsScreen> {
  void _openCreateAnnouncementModal(BuildContext context) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    String tag = 'Academic Notice';
    final admin = Provider.of<AdminProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Post Announcement 📢', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: StatefulBuilder(
          builder: (c, setStateModal) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  controller: titleController,
                  label: 'Headline',
                  hint: 'e.g. Mid-Term Examination Dates',
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: contentController,
                  label: 'Detailed Notice',
                  hint: 'Write instructions for students...',
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                Row(
                  children: ['Academic Notice', 'Project Guideline', 'Exam Alert'].map((t) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: ChoiceChip(
                          label: Center(child: Text(t, style: const TextStyle(fontSize: 10))),
                          selected: tag == t,
                          onSelected: (val) => setStateModal(() => tag = t),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty || contentController.text.trim().isEmpty) return;
              await admin.createAnnouncement(
                title: titleController.text.trim(),
                content: contentController.text.trim(),
                tag: tag,
              );
              Navigator.pop(ctx);
            },
            child: const Text('Publish Notice'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = Provider.of<AdminProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Announcements & Alerts 📢'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            tooltip: 'Create Notice',
            onPressed: () => _openCreateAnnouncementModal(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: admin.announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (ctx, i) {
          final a = admin.announcements[i];
          return Container(
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        a.tag,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      DateFormatter.formatShortDate(a.createdAt),
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  a.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  a.content,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.person_pin, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Posted by ${a.authorName}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateAnnouncementModal(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.campaign, color: Colors.white),
        label: const Text('Post Announcement', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
