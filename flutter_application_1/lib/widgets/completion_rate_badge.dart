import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Shows a fundi's job completion rate as a visual badge.
///
/// Displays the completion percentage with a color-coded indicator.
/// Uses trending up icon by default, with customizable styling options.
class CompletionRateBadge extends StatelessWidget {
  const CompletionRateBadge({
    super.key,
    required this.rate,
    this.showPercentage = true,
    this.showIcon = true,
    this.icon = Icons.trending_up,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.backgroundColorAlpha = 0.12,
    this.fontSize = 11,
    this.padding,
    this.borderRadius = 12,
    this.compactMode = false,
    this.label,
    this.elevation,
    this.animate = false,
  });

  /// Completion rate as a double between 0.0 and 1.0.
  final double rate;

  /// Whether to show the percentage text. Defaults to true.
  final bool showPercentage;

  /// Whether to show the icon. Defaults to true.
  final bool showIcon;

  /// Icon to display. Defaults to [Icons.trending_up].
  final IconData icon;

  /// Custom icon color. Uses rate-based color by default.
  final Color? iconColor;

  /// Custom text color. Uses rate-based color by default.
  final Color? textColor;

  /// Custom background color. Uses rate-based color with alpha by default.
  final Color? backgroundColor;

  /// Alpha value for background color. Defaults to 0.12.
  final double backgroundColorAlpha;

  /// Font size for the text. Defaults to 11.
  final double fontSize;

  /// Custom padding. Uses symmetric padding by default.
  final EdgeInsets? padding;

  /// Border radius. Defaults to 12.
  final double borderRadius;

  /// Whether to display in compact mode. Defaults to false.
  final bool compactMode;

  /// Custom label text. Uses 'X% completion' by default.
  final String? label;

  /// Elevation for shadow effect. Defaults to 0.
  final double elevation;

  /// Whether to animate the badge on appear. Defaults to false.
  final bool animate;

  /// Returns the completion percentage as an integer.
  int get percentage => (rate * 100).round();

  /// Returns the color based on the completion rate.
  Color get rateColor => rate >= 0.9
      ? AppColors.success
      : rate >= 0.7
      ? AppColors.warning
      : AppColors.error;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ??
        rateColor.withValues(alpha: backgroundColorAlpha);
    final effectiveIconColor = iconColor ?? rateColor;
    final effectiveTextColor = textColor ?? rateColor;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: compactMode ? 6 : 8,
      vertical: compactMode ? 2 : 3,
    );

    Widget badgeContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: compactMode ? 10 : 12, color: effectiveIconColor),
            const SizedBox(width: 4),
          ],
          if (showPercentage)
            Text(
              label ?? '$percentage% completion',
              style: TextStyle(
                color: effectiveTextColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );

    if (animate) {
      badgeContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: badgeContent,
      );
    }

    return badgeContent;
  }
}
