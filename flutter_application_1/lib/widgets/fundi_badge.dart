import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Achievement badges that fundis can earn.
enum FundiBadge {
  topRated('Top Rated', Icons.star, AppColors.starFilled),
  fastResponder('Fast Responder', Icons.bolt, AppColors.secondary),
  verified('Verified Pro', Icons.verified, AppColors.forestGreen),
  experienced('5+ Years', Icons.workspace_premium, AppColors.categoryCarpentry),
  popular('Popular', Icons.trending_up, AppColors.success);

  const FundiBadge(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Displays a fundi's achievement badges.
///
/// Shows a wrap of badge chips with customizable spacing and styling.
/// Empty list results in an empty widget.
class FundiBadgeDisplay extends StatelessWidget {
  const FundiBadgeDisplay({
    super.key,
    required this.badges,
    this.spacing = AppDimensions.spaceS,
    this.runSpacing = AppDimensions.spaceS,
    this.showEmptyPlaceholder = false,
    this.emptyPlaceholderText,
    this.emptyPlaceholderStyle,
    this.animate = false,
    this.padding,
  });

  /// List of badges to display.
  final List<FundiBadge> badges;

  /// Horizontal spacing between badges. Defaults to spaceS.
  final double spacing;

  /// Vertical spacing between runs. Defaults to spaceS.
  final double runSpacing;

  /// Whether to show a placeholder when no badges exist. Defaults to false.
  final bool showEmptyPlaceholder;

  /// Text for the empty placeholder. Uses 'No badges yet' by default.
  final String? emptyPlaceholderText;

  /// Style for the empty placeholder text.
  final TextStyle? emptyPlaceholderStyle;

  /// Whether to animate badge appearance. Defaults to false.
  final bool animate;

  /// Padding around the badge display.
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) {
      if (!showEmptyPlaceholder) return const SizedBox.shrink();

      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          emptyPlaceholderText ?? 'No badges yet',
          style: emptyPlaceholderStyle ??
              const TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
      );
    }

    Widget badgeContent = Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: [
        for (final badge in badges)
          _BadgeChip(badge: badge),
      ],
    );

    if (animate) {
      badgeContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: badgeContent,
      );
    }

    if (padding != null) {
      badgeContent = Padding(
        padding: padding!,
        child: badgeContent,
      );
    }

    return badgeContent;
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});
  final FundiBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: badge.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 14, color: badge.color),
          const SizedBox(width: 4),
          Text(
            badge.label,
            style: TextStyle(
              color: badge.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
