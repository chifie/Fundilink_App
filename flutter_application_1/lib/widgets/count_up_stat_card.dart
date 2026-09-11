import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import 'animated_count_up.dart';

/// A compact stat card whose value counts up when it first appears.
///
/// A drop-in upgrade for dashboards and summary rows: same layout as a
/// bordered stat card (icon, value, label) but the number animates from
/// zero to [value] using [AnimatedCountUp].
///
/// Example usage:
/// ```dart
/// CountUpStatCard(
///   label: AppStrings.pendingRequests,
///   value: requests.pendingCount.toDouble(),
///   icon: Icons.schedule,
///   color: AppColors.statusPending,
///   formatter: (v) => Formatters.currency(v),
/// )
/// ```
class CountUpStatCard extends StatelessWidget {
  const CountUpStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.formatter,
    this.duration = const Duration(milliseconds: 900),
    this.valueStyle,
    this.labelStyle,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  /// Label shown below the value.
  final String label;

  /// Target value the number counts up to.
  final double value;

  /// Icon displayed above the value.
  final IconData icon;

  /// Accent color for the icon and value.
  final Color color;

  /// Optional formatter for the rendered value (e.g. currency).
  final String Function(double value)? formatter;

  /// Duration of the count-up animation. Defaults to 900ms.
  final Duration duration;

  /// Custom text style for the value. Defaults to 22sp w800 in [color].
  final TextStyle? valueStyle;

  /// Custom text style for the label. Defaults to 11sp textHint.
  final TextStyle? labelStyle;

  /// Card background color. Defaults to [AppColors.surface].
  final Color? backgroundColor;

  /// Card border color. Defaults to [AppColors.border].
  final Color? borderColor;

  /// Optional tap callback for the card.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: borderColor ?? AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppDimensions.spaceS),
          AnimatedCountUp(
            value: value,
            duration: duration,
            formatter: formatter,
            style: valueStyle ??
                TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: labelStyle ??
                const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: card,
      ),
    );
  }
}
