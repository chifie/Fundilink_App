import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A simple bar chart showing earnings over the last 7 days.
class EarningsChart extends StatelessWidget {
  const EarningsChart({super.key, required this.dailyEarnings});
  final List<double> dailyEarnings;

  static const List<String> _days = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    final maxVal = dailyEarnings.isEmpty
        ? 1.0
        : dailyEarnings.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This Week',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final value = index < dailyEarnings.length
                    ? dailyEarnings[index]
                    : 0.0;
                final height = maxVal > 0 ? (value / maxVal) * 80 : 0.0;
                final isToday = index == DateTime.now().weekday - 1;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (value > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            value >= 1000
                                ? '${(value / 1000).toStringAsFixed(0)}K'
                                : value.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 8,
                              color: isToday
                                  ? AppColors.forestGreen
                                  : AppColors.textHint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: height.clamp(2, 80)),
                        duration: Duration(milliseconds: 400 + index * 60),
                        curve: Curves.easeOutCubic,
                        builder: (context, animatedHeight, _) {
                          return Container(
                            height: animatedHeight,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? AppColors.forestGreen
                                  : AppColors.forestGreen.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _days[index],
                        style: TextStyle(
                          fontSize: 10,
                          color: isToday
                              ? AppColors.forestGreen
                              : AppColors.textHint,
                          fontWeight: isToday
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
