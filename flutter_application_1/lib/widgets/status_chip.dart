import 'package:flutter/material.dart';

import '../models/service_request.dart';

/// Pill-shaped label reflecting a service request lifecycle status.
///
/// Can be displayed in compact or regular mode, with or without icon.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    this.compact = false,
    this.showIcon = true,
    this.backgroundColor,
    this.textColor,
    this.iconSize = 14,
    this.cornerRadius = 999,
    this.padding,
    this.labelStyle,
    this.iconSpacing = 4,
    this.onTap,
    this.elevation = 0,
  });

  /// The status to display.
  final RequestStatus status;

  /// Whether to display in compact mode with less padding. Defaults to false.
  final bool compact;

  /// Whether to show the status icon. Defaults to true.
  final bool showIcon;

  /// Custom background color. Uses status light color by default.
  final Color? backgroundColor;

  /// Custom text color. Uses status color by default.
  final Color? textColor;

  /// Size of the status icon. Defaults to 14.
  final double iconSize;

  /// Border radius of the chip. Defaults to fully rounded (999).
  final double cornerRadius;

  /// Custom padding for the chip. Uses compact-based padding by default.
  final EdgeInsets? padding;

  /// Custom text style for the label.
  final TextStyle? labelStyle;

  /// Spacing between icon and text. Defaults to 4.
  final double iconSpacing;

  /// Optional tap callback for interactive chips.
  final VoidCallback? onTap;

  /// Elevation of the chip when tapped. Defaults to 0.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = backgroundColor ?? status.lightColor;
    final effectiveTextColor = textColor ?? status.color;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 3 : 5,
        );

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && !compact) ...[
            Icon(status.icon, size: iconSize, color: effectiveTextColor),
            SizedBox(width: iconSpacing),
          ],
          Text(
            status.label,
            style: labelStyle ??
                TextStyle(
                  color: effectiveTextColor,
                  fontSize: compact ? 11 : 12,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(cornerRadius),
          child: content,
        ),
      );
    }

    return content;
  }
}
