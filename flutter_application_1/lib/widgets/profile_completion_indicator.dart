import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Shows profile completion progress as a circular indicator.
class ProfileCompletionIndicator extends StatelessWidget {
  const ProfileCompletionIndicator({super.key, required this.percentage});
  final double percentage;

  @override
  Widget build(BuildContext context) {
    final color = percentage >= 0.8 ? AppColors.success : percentage >= 0.5 ? AppColors.warning : AppColors.error;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                strokeWidth: 4,
                backgroundColor: AppColors.border,
                color: color,
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
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
