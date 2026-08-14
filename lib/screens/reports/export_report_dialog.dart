import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ExportReportDialog extends StatefulWidget {
  final Future<String> Function(String format) onExport;

  const ExportReportDialog({super.key, required this.onExport});

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  String _selectedFormat = 'PDF';
  bool _isExporting = false;
  String? _exportedContent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Export Academic Report 📄', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select export format to generate your syllabus completion dossier:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 14),
            Row(
              children: ['PDF', 'Summary Text', 'JSON'].map((fmt) {
                final isSelected = _selectedFormat == fmt;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: ChoiceChip(
                      label: Center(child: Text(fmt, style: const TextStyle(fontSize: 12))),
                      selected: isSelected,
                      onSelected: (val) => setState(() => _selectedFormat = fmt),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_exportedContent != null) ...[
              const Text('Generated Output Preview:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _exportedContent!,
                  style: const TextStyle(fontFamily: 'Courier', fontSize: 10),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ElevatedButton.icon(
          icon: const Icon(Icons.download, size: 16),
          label: Text(_isExporting ? 'Generating...' : 'Export $_selectedFormat'),
          onPressed: _isExporting
              ? null
              : () async {
                  setState(() => _isExporting = true);
                  final content = await widget.onExport(_selectedFormat);
                  setState(() {
                    _isExporting = false;
                    _exportedContent = content;
                  });
                },
        ),
      ],
    );
  }
}
