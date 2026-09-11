import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// A labeled section divider with optional action button.
///
/// Displays two horizontal dividers with optional label or child widget
/// in the center. Commonly used to separate sections in lists or forms.
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.label,
    this.child,
    this.horizontalPadding = 16,
    this.centerSpacing = 12,
    this.dividerColor,
    this.dividerThickness = 1,
    this.labelStyle,
    this.showDividers = true,
    this.verticalPadding = 8,
  });

  /// Optional text label to display in the center.
  final String? label;

  /// Optional custom widget to display in the center.
  final Widget? child;

  /// Horizontal padding for the divider. Defaults to 16.
  final double horizontalPadding;

  /// Spacing between dividers and center content. Defaults to 12.
  final double centerSpacing;

  /// Custom color for the dividers. Uses divider color by default.
  final Color? dividerColor;

  /// Thickness of the divider lines. Defaults to 1.
  final double dividerThickness;

  /// Custom text style for the label.
  final TextStyle? labelStyle;

  /// Whether to show the divider lines. Defaults to true.
  final bool showDividers;

  /// Vertical padding for the entire divider widget. Defaults to 8.
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    final effectiveDividerColor = dividerColor ?? AppColors.divider;
    final effectiveLabelStyle = labelStyle ??
        const TextStyle(
          color: AppColors.textHint,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );

    Widget dividerContent = Row(
      children: [
        if (showDividers)
          Expanded(
            child: Divider(
              color: effectiveDividerColor,
              thickness: dividerThickness,
            ),
          ),
        if (label != null || child != null) ...[
          SizedBox(width: centerSpacing),
          child ??
              Text(
                label!,
                style: effectiveLabelStyle,
              ),
          SizedBox(width: centerSpacing),
        ],
        if (showDividers)
          Expanded(
            child: Divider(
              color: effectiveDividerColor,
              thickness: dividerThickness,
            ),
          ),
      ],
    );

    if (!showDividers) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: child ?? Text(label!, style: effectiveLabelStyle),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: dividerContent,
    );
  }
}
