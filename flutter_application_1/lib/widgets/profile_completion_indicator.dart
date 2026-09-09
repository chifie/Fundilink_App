import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Shows profile completion progress as a circular indicator.
///
/// The ring and percentage smoothly animate towards [percentage] whenever
/// it changes.
class ProfileCompletionIndicator extends StatelessWidget {
  const ProfileCompletionIndicator({super.key, required this.percentage});
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final clamped = percentage.clamp(0.0, 1.0);
    final color = clamped >= 0.8
        ? AppColors.success
        : clamped >= 0.5
        ? AppColors.warning
        : AppColors.error;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: animatedValue,
                    strokeWidth: 4,
                    backgroundColor: AppColors.border,
                    color: color,
                  ),
                  Text(
                    '${(animatedValue * 100).round()}%',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spaceS),
        const Text(
          'Profile',
          style: TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
      ],
    );
  }
}