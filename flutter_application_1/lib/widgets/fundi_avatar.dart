import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/extensions/string_extensions.dart';
import '../core/utils/helpers.dart';

/// Deterministic avatar: shows a network photo when available and otherwise
/// falls back to initials on a colour derived from the person's name.
class FundiAvatar extends StatelessWidget {
  const FundiAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = AppDimensions.avatarM / 2,
    this.heroTag,
    this.useHero = false,
  });

  final String name;
  final String? imageUrl;
  final double radius;
  final Object? heroTag;
  final bool useHero;

  static const List<Color> _palette = [
    AppColors.primary,
    AppColors.secondaryDark,
    AppColors.categoryMasonry,
    AppColors.categoryCleaning,
    AppColors.categoryRepair,
    AppColors.categoryCarpentry,
  ];

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    final initials = name.initials;
    final fallbackColor = _palette[Helpers.colorSeed(name) % _palette.length];

    final fallback = CircleAvatar(
      radius: radius,
      backgroundColor: fallbackColor,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (url == null || url.isEmpty) {
      return useHero && heroTag != null
          ? Hero(tag: heroTag!, child: fallback)
          : fallback;
    }

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.surfaceVariant,
      foregroundImage: NetworkImage(url),
      onForegroundImageError: (_, _) {},
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    return useHero && heroTag != null
        ? Hero(tag: heroTag!, child: avatar)
        : avatar;
  }
}
