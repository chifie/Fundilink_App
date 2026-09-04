import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// A stat card displaying a value with label and optional icon.
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
    final effectiveColor = color ?? AppColors.primary;
    return Container(
      padding: EdgeInsets.all(compact ? 10 : AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: effectiveColor, size: compact ? 18 : 22),
            SizedBox(height: compact ? 4 : AppDimensions.spaceS),
          ],
          Text(
            value,
            style: TextStyle(
              color: effectiveColor,
              fontSize: compact ? 16 : 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: compact ? 2 : 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: compact ? 10 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
