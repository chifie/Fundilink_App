import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A reusable row with an icon and text, used for detail screens.
///
/// Displays an icon, primary text, and optional trailing widget in a
/// vertically padded row with customizable styling.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.trailing,
    this.iconSize = 18,
    this.iconColor,
    this.iconSpacing = AppDimensions.spaceM,
    this.textStyle,
    this.textAlign = TextAlign.start,
    this.verticalPadding = 6,
    this.horizontalPadding = 0,
    this.onTap,
    this.showDivider = false,
    this.dividerColor,
    this.elevation,
  });

  /// The icon to display.
  final IconData icon;

  /// The primary text to display.
  final String text;

  /// Optional widget to display after the text.
  final Widget? trailing;

  /// Size of the icon. Defaults to 18.
  final double iconSize;

  /// Color of the icon. Uses textHint by default.
  final Color? iconColor;

  /// Spacing between icon and text. Defaults to spaceM.
  final double iconSpacing;

  /// Custom text style for the main text.
  final TextStyle? textStyle;

  /// Text alignment for the main text. Defaults to left.
  final TextAlign textAlign;

  /// Vertical padding for the row. Defaults to 6.
  final double verticalPadding;

  /// Horizontal padding for the row. Defaults to 0.
  final double horizontalPadding;

  /// Optional tap callback for the row.
  final VoidCallback? onTap;

  /// Whether to show a divider below the row. Defaults to false.
  final bool showDivider;

  /// Custom color for the divider.
  final Color? dividerColor;

  /// Elevation for shadow effect. Defaults to 0.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? AppColors.textHint;
    final effectiveTextStyle = textStyle ??
        TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14,
          height: 1.4,
        );
    final effectiveDividerColor = dividerColor ?? AppColors.divider;

    Widget rowContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: effectiveIconColor,
          ),
          SizedBox(width: iconSpacing),
          Expanded(
            child: Text(
              text,
              style: effectiveTextStyle,
              textAlign: textAlign,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );

    if (elevation > 0 || onTap != null) {
      rowContent = Container(
        decoration: BoxDecoration(
          boxShadow: elevation > 0
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: elevation,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: rowContent,
      );
    }

    if (onTap != null) {
      rowContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: rowContent,
        ),
      );
    }

    if (showDivider) {
      return Column(
        children: [
          rowContent,
          Divider(
            color: effectiveDividerColor,
            thickness: 1,
            indent: horizontalPadding,
            endIndent: horizontalPadding,
          ),
        ],
      );
    }

    return rowContent;
  }
}
