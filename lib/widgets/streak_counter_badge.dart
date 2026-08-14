import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StreakCounterBadge extends StatelessWidget {
  final int streakDays;
  final bool isAnimated;

  const StreakCounterBadge({
    super.key,
    required this.streakDays,
    this.isAnimated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.streakFlameLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.streakFlame.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            '$streakDays Day Streak',
            style: const TextStyle(
              color: AppColors.streakFlame,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
