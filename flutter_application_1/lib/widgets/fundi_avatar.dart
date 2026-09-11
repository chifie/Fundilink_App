import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/extensions/string_extensions.dart';
import '../core/utils/helpers.dart';

/// Deterministic avatar: shows a network photo when available and otherwise
/// falls back to initials on a colour derived from the person's name.
///
/// Uses a deterministic color palette based on the name hash for consistent
/// avatar colors across the app.
class FundiAvatar extends StatelessWidget {
  const FundiAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = AppDimensions.avatarM / 2,
    this.heroTag,
    this.useHero = false,
    this.showOnlineIndicator = false,
    this.isOnline = false,
    this.backgroundColor,
    this.textStyle,
    this.diameter = 48,
  });

  /// The person's name, used for initials and color derivation.
  final String name;

  /// Optional URL to a network image.
  final String? imageUrl;

  /// Radius of the avatar. Only used if [diameter] is null.
  @Deprecated('Use diameter instead for clarity')
  final double radius;

  /// Hero tag for shared element transitions.
  final Object? heroTag;

  /// Whether to use Hero animation. Requires [heroTag] to be set.
  final bool useHero;

  /// Whether to show an online status indicator. Defaults to false.
  final bool showOnlineIndicator;

  /// Online status. Only relevant when [showOnlineIndicator] is true.
  final bool isOnline;

  /// Optional custom background color. Overrides derived color.
  final Color? backgroundColor;

  /// Optional custom text style for the initials.
  final TextStyle? textStyle;

  /// Diameter of the avatar in logical pixels. Defaults to 48.
  /// Takes precedence over [radius] when set.
  final double diameter;

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
    final hasImage = url != null && url.isNotEmpty;
    final initials = name.initials;
    final effectiveDiameter = diameter > 0 ? diameter : radius * 2;
    final effectiveRadius = effectiveDiameter / 2;
    final fallbackColor = backgroundColor ??
        _palette[Helpers.colorSeed(name) % _palette.length];

    final defaultTextStyle = textStyle ??
        TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: effectiveRadius * 0.7,
          fontWeight: FontWeight.w600,
        );

    Widget avatar = CircleAvatar(
      radius: effectiveRadius,
      backgroundColor: hasImage ? AppColors.surfaceVariant : fallbackColor,
      foregroundImage: hasImage ? NetworkImage(url) : null,
      onForegroundImageError: hasImage
          ? (exception, stackTrace) {
              // Silently fail - fall back to initials
            }
          : null,
      child: Text(
        initials,
        style: defaultTextStyle,
      ),
    );

    if (showOnlineIndicator) {
      avatar = Stack(
        alignment: Alignment.bottomRight,
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isOnline ? AppColors.success : AppColors.textHint,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (useHero && heroTag != null) {
      return Hero(tag: heroTag!, child: avatar);
    }

    return avatar;
  }
}
