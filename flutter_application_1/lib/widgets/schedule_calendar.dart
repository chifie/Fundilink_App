import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A weekly calendar view showing working days and time slots.
class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({
    super.key,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
  });

  final List<String> workingDays;
  final String startTime;
  final String endTime;

  static const List<String> _allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time range
        Row(
          children: [
            const Icon(Icons.access_time, size: 16, color: AppColors.forestGreen),
            const SizedBox(width: 6),
            Text(
              '$startTime – $endTime',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${workingDays.length}/7 days',
                style: const TextStyle(
                  color: AppColors.forestGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),

        // Day circles
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final day in _allDays)
              _DayCircle(
                day: day,
                isWorking: workingDays.contains(day),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spaceM),
        Text(
          'Working hours: $startTime – $endTime',
          style: const TextStyle(
            color: AppColors.textHint,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        _Legend(),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.forestGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Available',
          style: TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
        const SizedBox(width: 8),
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: Border(
              color: AppColors.border,
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Text(
          'Unavailable',
          style: TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  const _DayCircle({required this.day, required this.isWorking});
  final String day;
  final bool isWorking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isWorking ? AppColors.primary : AppColors.surfaceVariant,
            shape: BoxShape.circle,
            border: Border.all(
              color: isWorking ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              day.substring(0, 1),
              style: TextStyle(
                color: isWorking ? AppColors.textOnPrimary : AppColors.textHint,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          day,
          style: TextStyle(
            color: isWorking ? AppColors.primary : AppColors.textHint,
            fontSize: 10,
            fontWeight: isWorking ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
