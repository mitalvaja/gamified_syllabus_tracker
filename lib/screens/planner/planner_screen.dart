import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/planner_provider.dart';
import '../../providers/syllabus_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../widgets/priority_chip.dart';
import 'add_edit_task_dialog.dart';
import 'smart_suggestions_modal.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  void _openAddTaskDialog() {
    final syllabus = Provider.of<SyllabusProvider>(context, listen: false);
    final planner = Provider.of<PlannerProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AddTaskDialog(
        subjects: syllabus.subjects,
        initialDate: _selectedDay,
        onSave: ({
          int? topicId,
          required String subjectName,
          required String topicName,
          required DateTime date,
          required String startTime,
          required int durationMinutes,
          required String priority,
        }) {
          planner.addTask(
            topicId: topicId,
            subjectName: subjectName,
            topicName: topicName,
            date: date,
            startTime: startTime,
            durationMinutes: durationMinutes,
            priority: priority,
          );
        },
      ),
    );
  }

  void _openSmartSuggestions() {
    final planner = Provider.of<PlannerProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SmartSuggestionsModal(
        suggestions: planner.smartSuggestions,
        onAcceptSuggestion: (item) {
          final topic = item['topic'];
          planner.addTask(
            topicId: topic.id,
            subjectName: item['subjectName'],
            topicName: topic.name,
            date: _selectedDay,
            startTime: '10:00 AM',
            durationMinutes: 45,
            priority: topic.priority,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "${topic.name}" to today\'s study plan!'),
              backgroundColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final planner = Provider.of<PlannerProvider>(context);
    final gamification = Provider.of<GamificationProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Daily & Weekly Planner 📅'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: AppColors.primary),
            tooltip: 'Smart Suggestions',
            onPressed: _openSmartSuggestions,
          ),
          IconButton(
            icon: const Icon(Icons.add_task, color: AppColors.primary),
            tooltip: 'Schedule Task',
            onPressed: _openAddTaskDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // 7-day Horizontal Calendar Strip
          _buildWeeklyCalendarStrip(planner),

          // Date tasks overview header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatter.formatDisplayDate(_selectedDay),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${planner.todayCompletedCount} of ${planner.todayTotalCount} tasks completed',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                TextButton.icon(
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('Smart Suggestions'),
                  onPressed: _openSmartSuggestions,
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: planner.selectedDateTasks.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_note, size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'No study tasks planned for this day',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Keep your streak alive by scheduling a quick revision session!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _openAddTaskDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Schedule Task'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    itemCount: planner.selectedDateTasks.length,
                    itemBuilder: (ctx, i) {
                      final task = planner.selectedDateTasks[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: task.isCompleted ? AppColors.success.withOpacity(0.3) : AppColors.cardBorder,
                          ),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: task.isCompleted,
                              activeColor: AppColors.success,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              onChanged: (val) async {
                                final target = val ?? false;
                                await planner.toggleTaskCompletion(
                                  taskId: task.id,
                                  isCompleted: target,
                                  priority: task.priority,
                                  subjectName: task.subjectName,
                                  gamificationProvider: gamification,
                                );
                                if (target && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('🎉 Task Completed! +10 XP added to your total!'),
                                      backgroundColor: AppColors.primary,
                                      duration: Duration(seconds: 2),
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
                                      fontWeight: FontWeight.bold,
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
                                      const SizedBox(width: 6),
                                      const Text('•', style: TextStyle(color: AppColors.textMuted)),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${task.startTime} (${task.durationMinutes}m)',
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                PriorityChip(priority: task.priority),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () => planner.deleteTask(task.id),
                                  child: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddTaskDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildWeeklyCalendarStrip(PlannerProvider planner) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (idx) {
          final day = startOfWeek.add(Duration(days: idx));
          final isSelected = day.year == _selectedDay.year &&
              day.month == _selectedDay.month &&
              day.day == _selectedDay.day;
          final isToday = day.year == now.year && day.month == now.month && day.day == now.day;

          final weekDayName = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][idx];

          return GestureDetector(
            onTap: () {
              setState(() => _selectedDay = day);
              planner.setDate(day);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : isToday
                        ? AppColors.primaryLight
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isToday && !isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
              ),
              child: Column(
                children: [
                  Text(
                    weekDayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? AppColors.primary
                              : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : isToday
                              ? AppColors.primary
                              : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
