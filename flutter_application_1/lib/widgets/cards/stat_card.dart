import 'package:flutter/material.dart';

import '../../core/theme/app_card_styles.dart';
import '../../core/theme/app_text_styles.dart';

/// A stat card displaying a value with label and optional icon.
///
/// Uses the Material 3 outlined card treatment so stats stay flat and
/// readable on any surface, with the value colored by the active scheme.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveColor = color ?? scheme.primary;

    return Container(
      padding: EdgeInsets.all(compact ? 10 : 16),
      decoration: AppCardStyles.outlinedDecoration(scheme),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: effectiveColor, size: compact ? 18 : 22),
            SizedBox(height: compact ? 4 : 8),
          ],
          Text(
            value,
            style: (compact
                    ? textTheme.titleLarge
                    : textTheme.headlineSmall)!
                .copyWith(
              color: effectiveColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall(scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
