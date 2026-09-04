import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';

/// A styled price tag displaying a fundi's starting price.
class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, this.compact = false});
  final String price;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        price,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: compact ? 11 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
