import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A horizontal bar showing key fundi stats (jobs, rating, years).
class FundiStatsBar extends StatelessWidget {
  const FundiStatsBar({
    super.key,
    required this.completedJobs,
    required this.rating,
    required this.yearsExperience,
  });

  final int completedJobs;
  final double rating;
  final int yearsExperience;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
        vertical: AppDimensions.paddingS,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(icon: Icons.work_outline, value: '$completedJobs', label: 'Jobs'),
          _divider(),
          _StatItem(icon: Icons.star_outline, value: rating.toStringAsFixed(1), label: 'Rating'),
          _divider(),
          _StatItem(icon: Icons.school_outlined, value: '${yearsExperience}yr', label: 'Experience'),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.border,
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.icon, required this.value, required this.label});
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: const TextStyle(color: AppColors.textHint, fontSize: 10),
        ),
      ],
    );
  }
}
