import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// Achievement badges that fundis can earn.
enum FundiBadge {
  topRated('Top Rated', Icons.star, AppColors.starFilled),
  fastResponder('Fast Responder', Icons.bolt, AppColors.secondary),
  verified('Verified Pro', Icons.verified, AppColors.forestGreen),
  experienced('5+ Years', Icons.workspace_premium, AppColors.categoryCarpentry),
  popular('Popular', Icons.trending_up, AppColors.success);

  const FundiBadge(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Displays a fundi's achievement badges.
class FundiBadgeDisplay extends StatelessWidget {
  const FundiBadgeDisplay({super.key, required this.badges});
  final List<FundiBadge> badges;

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimensions.spaceS,
      runSpacing: AppDimensions.spaceS,
      children: [for (final badge in badges) _BadgeChip(badge: badge)],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.badge});
  final FundiBadge badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badge.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: badge.color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badge.icon, size: 14, color: badge.color),
          const SizedBox(width: 4),
          Text(
            badge.label,
            style: TextStyle(
              color: badge.color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
