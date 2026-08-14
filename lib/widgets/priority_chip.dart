import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PriorityChip extends StatelessWidget {
  final String priority;

  const PriorityChip({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label = priority.toUpperCase();

    switch (priority.toLowerCase()) {
      case 'high':
        bg = AppColors.dangerLight;
        fg = AppColors.danger;
        break;
      case 'low':
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case 'medium':
      default:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
