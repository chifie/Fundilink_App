import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// Screen-section heading with an optional trailing action link.
///
/// The header uses a 17sp bold primary color title and an optional 13sp
/// primary-colored action label on the right.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.description,
    this.titleStyle,
    this.actionLabelStyle,
    this.horizontalPadding = 16,
    this.verticalPadding = 8,
    this.actionIcon,
    this.showDivider = false,
    this.dividerColor,
    this.actionPadding = const SizedBox(width: 8),
    this.alignAction = TextAlign.right,
  });

  /// The title text for the section header.
  final String title;

  /// Optional action label shown on the right side.
  final String? actionLabel;

  /// Callback when the action label is tapped.
  final VoidCallback? onActionTap;

  /// Optional description text shown below the title.
  final String? description;

  /// Custom text style for the title.
  final TextStyle? titleStyle;

  /// Custom text style for the action label.
  final TextStyle? actionLabelStyle;

  /// Horizontal padding for the header. Defaults to 16.
  final double horizontalPadding;

  /// Vertical padding for the header. Defaults to 8.
  final double verticalPadding;

  /// Optional icon to display before the action label.
  final IconData? actionIcon;

  /// Whether to show a divider below the header. Defaults to false.
  final bool showDivider;

  /// Custom color for the divider. Uses divider color by default.
  final Color? dividerColor;

  /// Spacing widget before the action. Defaults to 8px width.
  final Widget actionPadding;

  /// Text alignment for the action. Defaults to right.
  final TextAlign alignAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveTitleStyle = titleStyle ??
        TextStyle(
          color: colorScheme.onSurface,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        );

    final effectiveActionStyle = actionLabelStyle ??
        TextStyle(
          color: colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );

    final dividerColorValue = dividerColor ?? AppColors.divider;

    Widget headerContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: effectiveTitleStyle,
                ),
              ),
              if (actionLabel != null && onActionTap != null) ...[
                actionPadding,
                GestureDetector(
                  onTap: onActionTap,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (actionIcon != null) ...[
                        Icon(
                          actionIcon,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        actionLabel!,
                        style: effectiveActionStyle,
                        textAlign: alignAction,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );

    if (showDivider) {
      return Column(
        children: [
          headerContent,
          Divider(
            color: dividerColorValue,
            thickness: 1,
            indent: horizontalPadding,
            endIndent: horizontalPadding,
          ),
        ],
      );
    }

    return headerContent;
  }
}
