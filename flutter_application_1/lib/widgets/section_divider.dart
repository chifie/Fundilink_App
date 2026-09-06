import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// A labeled section divider with optional action button.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.label, this.child});
  final String? label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Expanded(child: Divider(color: AppColors.divider)),
          if (label != null || child != null) ...[
            const SizedBox(width: 12),
            child ??
                Text(
                  label!,
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            const SizedBox(width: 12),
          ],
          const Expanded(child: Divider(color: AppColors.divider)),
        ],
      ),
    );
  }
}
