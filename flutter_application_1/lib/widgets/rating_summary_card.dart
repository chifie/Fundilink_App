import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import 'animated_count_up.dart';
import 'rating_stars.dart';

/// Shows a rating summary with distribution bars (5★ to 1★).
class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution, // [5star, 4star, 3star, 2star, 1star] counts
    this.showHeader = true,
  });

  final double averageRating;
  final int totalReviews;
  final List<int> distribution;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final maxCount = distribution.isEmpty
        ? 1
        : distribution.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(
        showHeader ? AppDimensions.paddingL : AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Left: big rating number
          SizedBox(
            width: 80,
            child: Column(
              children: [
                AnimatedCountUp(
                  value: averageRating,
                  duration: const Duration(milliseconds: 700),
                  formatter: (v) => v.toStringAsFixed(1),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                RatingStars(rating: averageRating, size: 14),
                const SizedBox(height: 4),
                Text(
                  '$totalReviews reviews',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceL),
          // Right: distribution bars
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starCount = index < distribution.length
                    ? distribution[index]
                    : 0;
                final percentage = maxCount > 0 ? starCount / maxCount : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '${5 - index}',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 10, color: AppColors.starFilled),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: percentage),
                          duration: Duration(milliseconds: 500 + index * 80),
                          curve: Curves.easeOutCubic,
                          builder: (context, animatedValue, _) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: animatedValue,
                                backgroundColor: AppColors.border,
                                color: AppColors.forestGreen,
                                minHeight: 6,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '$starCount',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 10,
                          ),
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
