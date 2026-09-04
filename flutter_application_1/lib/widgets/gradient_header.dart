import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A reusable gradient header card with child content.
class GradientHeader extends StatelessWidget {
  const GradientHeader({super.key, required this.child, this.colors});
  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: child,
    );
  }
}
