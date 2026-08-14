import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/syllabus_provider.dart';
import '../../providers/planner_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/level_progress_banner.dart';
import '../../widgets/streak_counter_badge.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/priority_chip.dart';
import '../../widgets/circular_progress_widget.dart';
import '../gamification/gamification_hub_screen.dart';
import '../gamification/leaderboard_screen.dart';
import '../gamification/badge_gallery_screen.dart';
import '../progress/progress_screen.dart';
import '../reports/reports_screen.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SyllabusProvider>(context, listen: false).fetchSubjects();
      Provider.of<PlannerProvider>(context, listen: false).fetchTasks();
      Provider.of<GamificationProvider>(context, listen: false).refreshGamificationData();
    });
  }

  void _showNotificationModal(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final notifs = notifProvider.notifications;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications & Reminders 🔔',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      notifProvider.markAllAsRead();
                      Navigator.pop(ctx);
                    },
                    child: const Text('Mark all read'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (notifs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No active notifications')),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: notifs.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (c, i) {
                      final n = notifs[i];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: n.type == 'streak'
                              ? AppColors.streakFlameLight
                              : AppColors.primaryLight,
                          child: Icon(
                            n.type == 'streak' ? Icons.local_fire_department : Icons.notifications_active,
                            color: n.type == 'streak' ? AppColors.streakFlame : AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(n.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(n.message, style: const TextStyle(fontSize: 12)),
                        trailing: Text(
                          DateFormatter.formatShortDate(n.createdAt),
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final syllabus = Provider.of<SyllabusProvider>(context);
    final planner = Provider.of<PlannerProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context);
    final notifs = Provider.of<NotificationProvider>(context);

    final userName = auth.user?.name.split(' ').first ?? 'Student';
    final streakDays = gamification.streak?.currentStreak ?? 7;
    final totalXp = gamification.levelInfo.currentXp;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, $userName 👋',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Ready to conquer today's study goals?",
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard_outlined, color: AppColors.primary),
            tooltip: 'Leaderboard',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: AppColors.primary),
            tooltip: 'Performance Reports',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReportsScreen()),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                onPressed: () => _showNotificationModal(context),
              ),
              if (notifs.unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                    child: Text(
                      '${notifs.unreadCount}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await syllabus.fetchSubjects();
          await planner.fetchTasks();
          await gamification.refreshGamificationData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gamified Level Banner
              LevelProgressBanner(
                levelInfo: gamification.levelInfo,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GamificationHubScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Quick Stats Grid (2x2)
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.45,
                children: [
                  StatCard(
                    title: "Today's Tasks",
                    value: "${planner.todayCompletedCount}/${planner.todayTotalCount}",
                    subtitle: planner.todayTotalCount == 0 ? "No tasks" : "${(planner.todayProgress * 100).round()}% done",
                    icon: Icons.checklist_rounded,
                    color: AppColors.primary,
                  ),
                  StatCard(
                    title: "Completed Topics",
                    value: "${syllabus.completedSyllabusTopics}",
                    subtitle: "of ${syllabus.totalSyllabusTopics} total",
                    icon: Icons.check_circle_outline,
                    color: AppColors.success,
                  ),
                  StatCard(
                    title: "Current Streak",
                    value: "$streakDays Days",
                    subtitle: "🔥 On Fire",
                    icon: Icons.local_fire_department,
                    color: AppColors.streakFlame,
                  ),
                  StatCard(
                    title: "Total XP Points",
                    value: "$totalXp XP",
                    subtitle: "Level ${gamification.levelInfo.level}",
                    icon: Icons.stars_rounded,
                    color: AppColors.xpGold,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Overall Syllabus Progress Card (Clickable to detailed ProgressScreen)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProgressScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: CircularProgressCard(
                  title: 'Overall Syllabus Progress',
                  percentage: syllabus.overallProgress,
                  centerText: '${syllabus.overallProgressPercent}%',
                  subtitle: '${syllabus.completedSyllabusTopics} of ${syllabus.totalSyllabusTopics} topics completed across 5 subjects.',
                  progressColor: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),

              // Today's Study Goals Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Study Goals 🎯",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to full planner view tab via parent or simple screen
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (planner.selectedDateTasks.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Center(
                    child: Text(
                      'No tasks scheduled for today. Add one from the Study Planner! 📚',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: planner.selectedDateTasks.length,
                  itemBuilder: (ctx, idx) {
                    final task = planner.selectedDateTasks[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: task.isCompleted ? AppColors.success.withOpacity(0.3) : AppColors.cardBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: task.isCompleted ? AppColors.success : AppColors.textMuted,
                              size: 26,
                            ),
                            onPressed: () async {
                              final wasCompleted = task.isCompleted;
                              final updated = await planner.toggleTaskCompletion(
                                taskId: task.id,
                                isCompleted: !wasCompleted,
                                priority: task.priority,
                                subjectName: task.subjectName,
                                gamificationProvider: gamification,
                              );
                              if (updated && !wasCompleted && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Text('🎉 Goal Completed! +10 XP earned!'),
                                        const Spacer(),
                                        StreakCounterBadge(streakDays: gamification.streak?.currentStreak ?? 7),
                                      ],
                                    ),
                                    backgroundColor: AppColors.primary,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.topicName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      task.subjectName,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('•', style: TextStyle(color: AppColors.textMuted)),
                                    const SizedBox(width: 8),
                                    Text(
                                      task.startTime,
                                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          PriorityChip(priority: task.priority),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 20),

              // Approaching Deadlines
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Deadlines ⏰',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildUpcomingDeadlines(syllabus),
              const SizedBox(height: 24),

              // Badges & Achievements Showcase
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Achievement Badges 🏆',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BadgeGalleryScreen()),
                      );
                    },
                    child: const Text('Badge Gallery'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildBadgesPreview(gamification),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingDeadlines(SyllabusProvider syllabus) {
    final List<Map<String, dynamic>> urgentItems = [];

    for (final s in syllabus.subjects) {
      for (final c in s.chapters) {
        for (final t in c.topics) {
          if (!t.isCompleted && t.targetDate != null) {
            urgentItems.add({
              'topicName': t.name,
              'subjectName': s.name,
              'targetDate': t.targetDate!,
              'priority': t.priority,
            });
          }
        }
      }
    }

    if (urgentItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: const Text('All deadlines are clear! Great job staying ahead.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Column(
      children: urgentItems.take(2).map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.warningLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timer_outlined, color: AppColors.warning, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['topicName'],
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      '${item['subjectName']} • Target: ${DateFormatter.formatDisplayDate(item['targetDate'])}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              PriorityChip(priority: item['priority']),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBadgesPreview(GamificationProvider gamification) {
    final badges = gamification.badges;
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (ctx, i) {
          final b = badges[i];
          return Container(
            width: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: b.isUnlocked ? AppColors.surface : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: b.isUnlocked ? AppColors.xpGold.withOpacity(0.5) : AppColors.cardBorder,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  b.iconEmoji,
                  style: TextStyle(
                    fontSize: 26,
                    color: b.isUnlocked ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  b.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: b.isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
