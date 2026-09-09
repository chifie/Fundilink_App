import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// A verification badge shown next to fundi names.
///
/// Displays the verified checkmark icon with customizable size and color.
/// Can optionally include text label alongside the icon.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({
    super.key,
    this.size = 16,
    this.color,
    this.showLabel = false,
    this.labelText,
    this.labelStyle,
    this.spacing = 4,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.elevation = 0,
    this.animate = false,
  });

  /// Size of the verification icon. Defaults to 16.
  final double size;

  /// Custom color for the icon. Uses primary color by default.
  final Color? color;

  /// Whether to show a text label alongside the icon. Defaults to false.
  final bool showLabel;

  /// Custom label text. Uses 'Verified' by default if showLabel is true.
  final String? labelText;

  /// Custom text style for the label.
  final TextStyle? labelStyle;

  /// Spacing between icon and label. Defaults to 4.
  final double spacing;

  /// Custom background color for the badge container.
  final Color? backgroundColor;

  /// Padding around the badge content.
  final EdgeInsets? padding;

  /// Border radius for the badge container.
  final BorderRadius? borderRadius;

  /// Elevation for shadow effect. Defaults to 0.
  final double elevation;

  /// Whether to animate the badge on appear. Defaults to false.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveLabelText = labelText ?? 'Verified';
    final effectiveLabelStyle = labelStyle ??
        TextStyle(
          color: effectiveColor,
          fontSize: size * 0.6,
          fontWeight: FontWeight.w600,
        );
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: size * 0.5,
      vertical: size * 0.2,
    );
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(size / 2);

    Widget badgeContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.verified,
          size: size,
          color: effectiveColor,
        ),
        if (showLabel) ...[
          SizedBox(width: spacing),
          Text(
            effectiveLabelText,
            style: effectiveLabelStyle,
          ),
        ],
      ],
    );

    if (backgroundColor != null) {
      badgeContent = Container(
        padding: effectivePadding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: effectiveBorderRadius,
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: elevation,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: badgeContent,
      );
    }

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
