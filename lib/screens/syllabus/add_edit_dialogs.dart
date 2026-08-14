import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddSubjectDialog extends StatefulWidget {
  final Function(String name, String code, String description, int colorHex) onSave;

  const AddSubjectDialog({super.key, required this.onSave});

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _descController = TextEditingController();
  int _selectedColorHex = 0xFF4F46E5;

  final List<int> _colors = [
    0xFF4F46E5, // Indigo
    0xFF0EA5E9, // Sky
    0xFF10B981, // Emerald
    0xFF8B5CF6, // Violet
    0xFFF59E0B, // Amber
    0xFFEF4444, // Red
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add New Subject 📚', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Subject Name',
                hint: 'e.g. Operating Systems',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _codeController,
                label: 'Subject Code',
                hint: 'e.g. BCA-505',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descController,
                label: 'Description',
                hint: 'Course curriculum overview...',
                maxLines: 2,
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Theme Color', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _colors.map((c) {
                  final isSelected = _selectedColorHex == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorHex = c),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: isSelected ? Border.all(color: Colors.black, width: 2.5) : null,
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
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            widget.onSave(
              _nameController.text.trim(),
              _codeController.text.trim(),
              _descController.text.trim(),
              _selectedColorHex,
            );
            Navigator.pop(context);
          },
          child: const Text('Add Subject'),
        ),
      ],
    );
  }
}

class AddChapterDialog extends StatefulWidget {
  final int subjectId;
  final Function(String name, String description, DateTime? targetDate) onSave;

  const AddChapterDialog({super.key, required this.subjectId, required this.onSave});

  @override
  State<AddChapterDialog> createState() => _AddChapterDialogState();
}

class _AddChapterDialogState extends State<AddChapterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _targetDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Unit / Chapter 📑', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Chapter Title',
                hint: 'e.g. Unit 3: Memory Management',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descController,
                label: 'Description / Scope',
                hint: 'Key syllabus outcomes...',
                maxLines: 2,
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Target Completion Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(DateFormatter.formatDisplayDate(_targetDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month, color: AppColors.primary),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 7)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _targetDate = picked);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            widget.onSave(_nameController.text.trim(), _descController.text.trim(), _targetDate);
            Navigator.pop(context);
          },
          child: const Text('Create Chapter'),
        ),
      ],
    );
  }
}

class AddTopicDialog extends StatefulWidget {
  final int chapterId;
  final Function(String name, String description, String priority, DateTime? targetDate) onSave;

  const AddTopicDialog({super.key, required this.chapterId, required this.onSave});

  @override
  State<AddTopicDialog> createState() => _AddTopicDialogState();
}

class _AddTopicDialogState extends State<AddTopicDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'medium';
  DateTime? _targetDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Add Study Topic 📌', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Topic Name',
                hint: 'e.g. Page Replacement Algorithms',
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _descController,
                label: 'Key Concepts & Notes',
                hint: 'FIFO, LRU, Optimal algorithms...',
                maxLines: 2,
              ),
              const SizedBox(height: 14),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Priority Level', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 6),
              Row(
                children: ['high', 'medium', 'low'].map((p) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ChoiceChip(
                        label: Center(child: Text(p.toUpperCase(), style: const TextStyle(fontSize: 11))),
                        selected: _priority == p,
                        onSelected: (val) => setState(() => _priority = p),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Target Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                subtitle: Text(DateFormatter.formatDisplayDate(_targetDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month, color: AppColors.primary),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 3)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 180)),
                    );
                    if (picked != null) setState(() => _targetDate = picked);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            widget.onSave(_nameController.text.trim(), _descController.text.trim(), _priority, _targetDate);
            Navigator.pop(context);
          },
          child: const Text('Save Topic'),
        ),
      ],
    );
  }
}
