import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../core/constants/app_colors.dart';

/**
 * A shimmer loading skeleton effect used while content loads.
 *
 * Wraps a child widget with a shimmer animation to indicate loading.
 * Can be customized with base and highlight colors, direction, and
 * duration.
 *
 * Example:
 * ```dart
 * ShimmerLoading(
 *   direction: ShimmerDirection.rtl,
 *   enabled: true,
 *   child: Container(height: 100, width: 200),
 * )
 * ```
 */
class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
    this.direction = ShimmerDirection.ltr,
    this.duration = const Duration(milliseconds: 1500),
  });

  /// The child widget to apply the shimmer effect to.
  final Widget child;

  /// Base color for the shimmer. Defaults to [AppColors.surfaceVariant].
  final Color? baseColor;

  /// Highlight color for the shimmer. Defaults to [AppColors.surface].
  final Color? highlightColor;

  /// Whether the shimmer animation is enabled. Defaults to true.
  /// Set to false to show static placeholder without animation.
  final bool enabled;

  /// Direction of the shimmer animation. Defaults to [ShimmerDirection.ltr].
  final ShimmerDirection direction;

  /// Duration of one shimmer cycle. Defaults to 1500ms.
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = baseColor ?? colorScheme.surfaceContainerHighest;
    final highlight = highlightColor ?? colorScheme.surface;

    if (!enabled) {
      return Container(
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
    }

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      direction: direction,
      period: duration,
      child: child,
    );
  }
}

/// A shimmer placeholder card that mimics a fundi card layout.
class ShimmerFundiCard extends StatelessWidget {
  const ShimmerFundiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.surfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 120,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      width: 160,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a horizontal list item (compact fundi card).
class ShimmerCompactCard extends StatelessWidget {
  const ShimmerCompactCard({super.key, this.showOnlineIndicator = true});

  /// Whether to show the online status indicator dot.
  final bool showOnlineIndicator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceVariant = colorScheme.surfaceContainerHighest;

    return ShimmerLoading(
      child: SizedBox(
        width: 180,
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: surfaceVariant,
                    ),
                    const Spacer(),
                    if (showOnlineIndicator)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: surfaceVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 12,
                  width: 70,
                  decoration: BoxDecoration(
                    color: surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    5,
                    (_) => Container(
                      margin: const EdgeInsets.only(right: 2),
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: surfaceVariant,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer placeholder for a category grid item.
class ShimmerCategoryItem extends StatelessWidget {
  const ShimmerCategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
