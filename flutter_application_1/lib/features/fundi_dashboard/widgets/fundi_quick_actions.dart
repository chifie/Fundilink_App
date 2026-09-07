import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../earnings/screens/earnings_screen.dart';
import '../../fundi_availability/screens/availability_screen.dart';
import '../../fundi_portfolio/screens/portfolio_screen.dart';
import '../../fundi_profile_mgmt/screens/profile_mgmt_screen.dart';

/// Quick action buttons for common fundi tasks.
class FundiQuickActions extends StatelessWidget {
  const FundiQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.person_outline,
          label: AppStrings.profile,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const ProfileMgmtScreen()),
          ),
        ),
        _ActionButton(
          icon: Icons.event_available_outlined,
          label: AppStrings.schedule,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const AvailabilityScreen()),
          ),
        ),
        _ActionButton(
          icon: Icons.photo_library_outlined,
          label: AppStrings.portfolio,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const PortfolioScreen()),
          ),
        ),
        _ActionButton(
          icon: Icons.account_balance_wallet_outlined,
          label: AppStrings.earnings,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const EarningsScreen()),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: AppDimensions.spaceS),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
