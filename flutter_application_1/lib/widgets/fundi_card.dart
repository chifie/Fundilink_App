import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../models/fundi_model.dart';
import '../widgets/fundi_avatar.dart';
import '../widgets/rating_stars.dart';

/// Full-width fundi row used in vertical result lists.
///
/// Displays fundi avatar, name, verification status, category,
/// rating with value, price, and location information.
class FundiCard extends StatelessWidget {
  const FundiCard({
    super.key,
    required this.fundi,
    this.onTap,
    this.showVerified = true,
    this.showPrice = true,
    this.showLocation = true,
    this.avatarRadius,
    this.avatarUseHero = true,
    this.avatarHeroTag,
    this.nameStyle,
    this.categoryStyle,
    this.priceStyle,
    this.locationStyle,
    this.cardMargin,
    this.cardPadding,
    this.cardBorderRadius,
    this.showCategory = true,
    this.animate = false,
    this.elevation = 0,
  });

  /// The fundi data to display.
  final Fundi fundi;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

  /// Whether to show the verified icon. Defaults to true.
  final bool showVerified;

  /// Whether to show the price tag. Defaults to true.
  final bool showPrice;

  /// Whether to show the location info. Defaults to true.
  final bool showLocation;

  /// Whether to show the category name. Defaults to true.
  final bool showCategory;

  /// Radius of the avatar. Uses default if null.
  final double? avatarRadius;

  /// Whether to use Hero animation for the avatar. Defaults to true.
  final bool avatarUseHero;

  /// Hero tag for the avatar animation.
  final Object? avatarHeroTag;

  /// Custom text style for the fundi name.
  final TextStyle? nameStyle;

  /// Custom text style for the category name.
  final TextStyle? categoryStyle;

  /// Custom text style for the price text.
  final TextStyle? priceStyle;

  /// Custom text style for the location text.
  final TextStyle? locationStyle;

  /// Margin around the card.
  final EdgeInsets? cardMargin;

  /// Padding inside the card.
  final EdgeInsets? cardPadding;

  /// Border radius for the card.
  final BorderRadius? cardBorderRadius;

  /// Whether to animate the card appearance. Defaults to false.
  final bool animate;

  /// Elevation of the card. Defaults to 0.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final effectiveAvatarRadius = avatarRadius ?? 24;
    final effectiveCardMargin = cardMargin ??
        EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        );
    final effectiveCardPadding = cardPadding ?? EdgeInsets.all(
      AppDimensions.paddingM,
    );
    final effectiveCardBorderRadius = cardBorderRadius ??
        BorderRadius.circular(AppDimensions.cardRadius);
    final effectiveHeroTag = avatarHeroTag ?? 'fundi-avatar-${fundi.id}';

    Widget cardContent = Card(
      margin: effectiveCardMargin,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveCardBorderRadius,
      ),
      child: InkWell(
        borderRadius: effectiveCardBorderRadius,
        onTap: onTap,
        child: Padding(
          padding: effectiveCardPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FundiAvatar(
                name: fundi.fullName,
                imageUrl: fundi.avatarUrl,
                radius: effectiveAvatarRadius,
                useHero: avatarUseHero,
                heroTag: effectiveHeroTag,
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fundi.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: nameStyle ??
                                const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        if (showVerified && fundi.verified) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                    if (showCategory) ...[
                      const SizedBox(height: 2),
                      Text(
                        fundi.categoryName,
                        style: categoryStyle ??
                            const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                            ),
                      ),
                    ],
                    if (showCategory) const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingStars(
                          rating: fundi.rating,
                          showValue: true,
                        ),
                        const Spacer(),
                        if (showPrice)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primarySurface,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              'KES ${fundi.startingPrice.toStringAsFixed(0)}${fundi.priceUnit}',
                              style: priceStyle ??
                                  const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    if (showLocation) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              '${fundi.location} · ${fundi.distanceKm.toStringAsFixed(1)} km away',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: locationStyle ??
                                  const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (animate) {
      cardContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Compact fixed-width card used in horizontal "recommended" strips.
class FundiCardCompact extends StatelessWidget {
  const FundiCardCompact({super.key, required this.fundi, this.onTap});

  final Fundi fundi;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    FundiAvatar(
                      name: fundi.fullName,
                      imageUrl: fundi.avatarUrl,
                      radius: 22,
                    ),
                    const Spacer(),
                    if (fundi.isAvailable)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  fundi.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fundi.categoryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingStars(rating: fundi.rating, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      fundi.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        '${fundi.distanceKm.toStringAsFixed(1)} km',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
