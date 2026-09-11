import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../core/constants/app_dimensions.dart';
import '../core/utils/formatters.dart';
import '../models/review.dart';
import 'fundi_avatar.dart';
import 'rating_stars.dart';

/// One customer review with author, stars, comment and relative time.
///
/// Displays a review tile with customer avatar, name, rating stars,
/// review comment, and relative time. Fully customizable.
class ReviewTile extends StatelessWidget {
  const ReviewTile({
    super.key,
    required this.review,
    this.avatarRadius = 16,
    this.showAvatar = true,
    this.showRating = true,
    this.showTime = true,
    this.showComment = true,
    this.avatarUseHero = false,
    this.avatarHeroTag,
    this.customerNameStyle,
    this.commentStyle,
    this.timeStyle,
    this.ratingSize = 13,
    this.verticalPadding = AppDimensions.paddingS,
    this.horizontalPadding = 0,
    this.avatarSpacing = AppDimensions.spaceM,
    this.ratingSpacing = 4,
    this.timeSpacing = 8,
    this.onCustomerTap,
    this.onReviewTap,
    this.animate = false,
    this.showVerifiedBadge = false,
  });

  /// The review data to display.
  final Review review;

  /// Radius of the customer avatar. Defaults to 16.
  final double avatarRadius;

  /// Whether to show the customer avatar. Defaults to true.
  final bool showAvatar;

  /// Whether to show the rating stars. Defaults to true.
  final bool showRating;

  /// Whether to show the relative time. Defaults to true.
  final bool showTime;

  /// Whether to show the review comment. Defaults to true.
  final bool showComment;

  /// Whether to use Hero animation for the avatar.
  final bool avatarUseHero;

  /// Hero tag for the avatar animation.
  final Object? avatarHeroTag;

  /// Custom text style for the customer name.
  final TextStyle? customerNameStyle;

  /// Custom text style for the comment.
  final TextStyle? commentStyle;

  /// Custom text style for the time.
  final TextStyle? timeStyle;

  /// Size of the rating stars. Defaults to 13.
  final double ratingSize;

  /// Vertical padding for the tile. Defaults to paddingS.
  final double verticalPadding;

  /// Horizontal padding for the tile. Defaults to 0.
  final double horizontalPadding;

  /// Spacing between avatar and content. Defaults to spaceM.
  final double avatarSpacing;

  /// Spacing between rating and other elements. Defaults to 4.
  final double ratingSpacing;

  /// Spacing before the time text. Defaults to 8.
  final double timeSpacing;

  /// Callback when the customer name is tapped.
  final VoidCallback? onCustomerTap;

  /// Callback when the entire review is tapped.
  final VoidCallback? onReviewTap;

  /// Whether to animate the tile appearance. Defaults to false.
  final bool animate;

  /// Whether to show a verified badge next to the customer name.
  final bool showVerifiedBadge;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget tileContent = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            FundiAvatar(
              name: review.customerName,
              radius: avatarRadius,
              useHero: avatarUseHero,
              heroTag: avatarHeroTag,
            ),
          if (showAvatar) SizedBox(width: avatarSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onCustomerTap,
                        child: Text(
                          review.customerName,
                          style: customerNameStyle ??
                              TextStyle(
                                color: colorScheme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    if (showTime) ...[
                      SizedBox(width: timeSpacing),
                      Text(
                        Formatters.timeAgo(review.createdAt),
                        style: timeStyle ??
                            const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                      ),
                    ],
                  ],
                ),
                if (showRating) ...[
                  const SizedBox(height: 2),
                  RatingStars(
                    rating: review.rating,
                    size: ratingSize,
                  ),
                ],
                if (showRating && showComment) SizedBox(height: ratingSpacing),
                if (showComment)
                  Text(
                    review.comment,
                    style: commentStyle ??
                        TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                          height: 1.4,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (animate) {
      tileContent = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: tileContent,
      );
    }

    if (onReviewTap != null) {
      tileContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onReviewTap,
          child: tileContent,
        ),
      );
    }

    return tileContent;
  }
}
