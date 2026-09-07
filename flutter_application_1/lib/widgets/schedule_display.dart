import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Displays a fundi's working schedule in a compact row.
///
/// Shows working days, start time, end time, and a summary line.
/// Fully customizable with support for different time formats.
class ScheduleDisplay extends StatelessWidget {
  const ScheduleDisplay({
    super.key,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    this.icon = Icons.schedule,
    this.iconSize = 20,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.showIcon = true,
    this.showSummary = true,
    this.iconSpacing = AppDimensions.spaceM,
    this.summarySuffix = 'days per week',
    this.onTap,
    this.animate = false,
    this.daySeparator = ', ',
    this.timeSeparator = ' - ',
  });

  /// List of working day names (e.g., ['Mon', 'Wed', 'Fri']).
  final List<String> workingDays;

  /// Start time string (e.g., '9:00 AM').
  final String startTime;

  /// End time string (e.g., '5:00 PM').
  final String endTime;

  /// Icon to display. Defaults to [Icons.schedule].
  final IconData icon;

  /// Size of the icon. Defaults to 20.
  final double iconSize;

  /// Color of the icon. Uses primary color by default.
  final Color? iconColor;

  /// Custom text style for the main schedule text.
  final TextStyle? titleStyle;

  /// Custom text style for the summary text.
  final TextStyle? subtitleStyle;

  /// Padding for the container. Uses paddingM by default.
  final EdgeInsets? padding;

  /// Border radius for the container. Uses radiusM by default.
  final BorderRadius? borderRadius;

  /// Background color for the container. Uses surface color by default.
  final Color? backgroundColor;

  /// Border color for the container. Uses border color by default.
  final Color? borderColor;

  /// Whether to show the icon. Defaults to true.
  final bool showIcon;

  /// Whether to show the summary text. Defaults to true.
  final bool showSummary;

  /// Spacing between icon and content. Defaults to spaceM.
  final double iconSpacing;

  /// Suffix for the summary text. Defaults to 'days per week'.
  final String summarySuffix;

  /// Optional tap callback for the schedule display.
  final VoidCallback? onTap;

  /// Whether to animate the display on appear. Defaults to false.
  final bool animate;

  /// Separator between working days. Defaults to ', '.
  final String daySeparator;

  /// Separator between start and end time. Defaults to ' - '.
  final String timeSeparator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveTitleStyle = titleStyle ??
        TextStyle(
          color: colorScheme.onSurface,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
    final effectiveSubtitleStyle = subtitleStyle ??
        TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12,
        );
    final effectivePadding = padding ?? EdgeInsets.all(AppDimensions.paddingM);
    final effectiveBorderRadius = borderRadius ??
        BorderRadius.circular(AppDimensions.radiusM);
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;
    final effectiveBorderColor = borderColor ?? AppColors.border;

    Widget scheduleContent = Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
        border: Border.all(color: effectiveBorderColor),
      ),
      child: Row(
        children: [
          if (showIcon)
            Icon(
              icon,
              color: effectiveIconColor,
              size: iconSize,
            ),
          if (showIcon) SizedBox(width: iconSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${workingDays.join(daySeparator)}'
                  '$timeSeparator${startTime}${timeSeparator}$endTime',
                  style: effectiveTitleStyle,
                ),
                if (showSummary) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${workingDays.length} $summarySuffix',
                    style: effectiveSubtitleStyle,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (animate) {
      scheduleContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: scheduleContent,
      );
    }

    if (onTap != null) {
      scheduleContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveBorderRadius,
          child: scheduleContent,
        ),
      );
    }

    return scheduleContent;
  }
}
