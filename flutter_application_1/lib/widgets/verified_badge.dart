import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

/// A verification badge shown next to fundi names.
class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, this.size = 16});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.verified, size: size, color: AppColors.primary);
  }
}
