import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../models/subject_model.dart';
import '../../widgets/custom_text_field.dart';

class AddTaskDialog extends StatefulWidget {
  final List<SubjectModel> subjects;
  final DateTime initialDate;
  final Function({
    int? topicId,
    required String subjectName,
    required String topicName,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required String priority,
  }) onSave;

  const AddTaskDialog({
    super.key,
    required this.subjects,
    required this.initialDate,
    required this.onSave,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedSubject;
  String? _selectedTopic;
  int? _selectedTopicId;
  final _customTopicController = TextEditingController();
  late DateTime _selectedDate;
  String _startTime = '10:00 AM';
  int _duration = 45;
  String _priority = 'medium';

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    if (widget.subjects.isNotEmpty) {
      _selectedSubject = widget.subjects.first.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentSubject = widget.subjects.firstWhere(
      (s) => s.name == _selectedSubject,
      orElse: () => widget.subjects.isNotEmpty
          ? widget.subjects.first
          : SubjectModel(id: 0, name: 'General'),
    );

    final availableTopics = currentSubject.allTopics;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Schedule Study Task 📅', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Subject
              const Text('Subject', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedSubject,
                decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                items: widget.subjects.map((s) {
                  return DropdownMenuItem(value: s.name, child: Text(s.name, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSubject = val;
                    _selectedTopic = null;
                    _selectedTopicId = null;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Select Topic or write custom
              const Text('Topic', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              if (availableTopics.isNotEmpty) ...[
                DropdownButtonFormField<String>(
                  value: _selectedTopic,
                  hint: const Text('Choose topic from syllabus', style: TextStyle(fontSize: 13)),
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                  items: availableTopics.map((t) {
                    return DropdownMenuItem(value: t.name, child: Text(t.name, style: const TextStyle(fontSize: 13)));
                  }).toList(),
                  onChanged: (val) {
                    final t = availableTopics.firstWhere((x) => x.name == val);
                    setState(() {
                      _selectedTopic = val;
                      _selectedTopicId = t.id;
                      _priority = t.priority;
                    });
                  },
                ),
                const SizedBox(height: 6),
              ],
              CustomTextField(
                controller: _customTopicController,
                label: 'Or Custom Task Name',
                hint: _selectedTopic != null ? 'Selected from syllabus' : 'e.g. Solve Unit 2 Question Bank',
              ),
              const SizedBox(height: 12),

              // Date & Time Picker
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 7)),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (picked != null) setState(() => _selectedDate = picked);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Date', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            Text(DateFormatter.formatShortDate(_selectedDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 10, minute: 0),
                        );
                        if (time != null) {
                          setState(() => _startTime = time.format(context));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Time', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                            Text(_startTime, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Duration & Priority
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _duration,
                      decoration: const InputDecoration(labelText: 'Duration'),
                      items: const [
                        DropdownMenuItem(value: 30, child: Text('30 mins')),
                        DropdownMenuItem(value: 45, child: Text('45 mins')),
                        DropdownMenuItem(value: 60, child: Text('60 mins')),
                        DropdownMenuItem(value: 90, child: Text('90 mins')),
                      ],
                      onChanged: (val) => setState(() => _duration = val ?? 45),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      decoration: const InputDecoration(labelText: 'Priority'),
                      items: const [
                        DropdownMenuItem(value: 'high', child: Text('HIGH 🔴')),
                        DropdownMenuItem(value: 'medium', child: Text('MEDIUM 🟡')),
                        DropdownMenuItem(value: 'low', child: Text('LOW 🟢')),
                      ],
                      onChanged: (val) => setState(() => _priority = val ?? 'medium'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final topicName = _selectedTopic ?? _customTopicController.text.trim();
            if (topicName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select or enter a topic name')),
              );
              return;
            }

            widget.onSave(
              topicId: _selectedTopicId,
              subjectName: _selectedSubject ?? 'General Study',
              topicName: topicName,
              date: _selectedDate,
              startTime: _startTime,
              durationMinutes: _duration,
              priority: _priority,
            );
            Navigator.pop(context);
          },
          child: const Text('Schedule Task'),
        ),
      ],
    );
  }
}
