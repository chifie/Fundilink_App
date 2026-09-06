import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A card with a toggle for fundi online/offline status.
class AvailabilityToggleCard extends StatelessWidget {
  const AvailabilityToggleCard({
    super.key,
    required this.isAvailable,
    required this.onToggle,
  });

  final bool isAvailable;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.successLight : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isAvailable ? AppColors.success : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAvailable ? AppColors.success : AppColors.textHint,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAvailable ? Icons.check : Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable ? 'You\'re online' : 'You\'re offline',
                  style: TextStyle(
                    color: isAvailable
                        ? AppColors.success
                        : AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isAvailable
                      ? 'Accepting new service requests'
                      : 'Not receiving new requests',
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isAvailable,
            onChanged: onToggle,
            activeThumbColor: AppColors.success,
          ),
        ],
      ),
    );
  }
}
