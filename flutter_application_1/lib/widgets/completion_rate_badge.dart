import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// Shows a fundi's job completion rate as a visual badge.
class CompletionRateBadge extends StatelessWidget {
  const CompletionRateBadge({super.key, required this.rate});
  final double rate;

  @override
  Widget build(BuildContext context) {
    final percentage = (rate * 100).toInt();
    final color = rate >= 0.9
        ? AppColors.success
        : rate >= 0.7
        ? AppColors.warning
        : AppColors.error;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '$percentage% completion',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
