import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'animated_count_up.dart';

/// Shows a fundi's average response time as a badge.
class ResponseTimeBadge extends StatelessWidget {
  const ResponseTimeBadge({super.key, required this.minutes, this.animate = false});

  /// Average response time in minutes.
  final int minutes;

  /// Whether the minutes count up when the badge appears.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final color = minutes <= 15
        ? AppColors.success
        : minutes <= 30
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
          Icon(Icons.timer_outlined, size: 12, color: color),
          const SizedBox(width: 4),
          if (animate)
            AnimatedCountUp(
              value: minutes.toDouble(),
              duration: const Duration(milliseconds: 600),
              formatter: (v) => '${v.round()}min response',
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              '${minutes}min response',
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
