import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// A small read-only star row used wherever a fundi rating is shown.
///
/// Displays 5 stars with filled, half, or empty states based on the
/// rating value. Optionally shows the numeric rating value.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.showValue = false,
    this.starFilledColor,
    this.starEmptyColor,
    this.valueStyle,
    this.maxRating = 5,
    this.halfStarThreshold = 0.5,
    this.animate = false,
  });

  /// The rating value, typically between 0.0 and [maxRating].
  final double rating;

  /// Size of each star icon in logical pixels. Defaults to 16.
  final double size;

  /// Whether to show the numeric rating value after the stars. Defaults to false.
  final bool showValue;

  /// Custom color for filled stars. Defaults to [AppColors.starFilled].
  final Color? starFilledColor;

  /// Custom color for empty stars. Defaults to [AppColors.starEmpty].
  final Color? starEmptyColor;

  /// Custom text style for the numeric value. Defaults to theme-appropriate styling.
  final TextStyle? valueStyle;

  /// Maximum number of stars. Defaults to 5.
  final int maxRating;

  /// Threshold for half-star display. Defaults to 0.5.
  final double halfStarThreshold;

  /// Whether to animate the stars on appear. Defaults to false.
  final bool animate;

  /// Returns true if the rating is considered high (>= 4.0 for 5-star scale).
  bool get isHighRating => rating >= (maxRating - 1);

  /// Returns true if the rating is considered low (< 3.0 for 5-star scale).
  bool get isLowRating => rating < 3.0;

  /// Returns the integer part of the rating.
  int get fullStars => rating.floor().clamp(0, maxRating);

  /// Returns the fractional part of the rating for half-star display.
  double get fractionalPart => (rating - fullStars).clamp(0.0, 1.0);

  /// Returns a list of (index, isFilled) pairs for all stars.
  List<(int, bool)> get starStates {
    return List.generate(maxRating, (index) {
      final starValue = index + 1;
      return (index, rating >= starValue - halfStarThreshold);
    });
  }

  /// Returns whether to show a half-star for the given position.
  bool hasHalfStarAt(int position) {
    final starValue = position + 1;
    return rating < starValue && rating >= starValue - halfStarThreshold;
  }

  /// Returns the display string for the rating (e.g., "4.5").
  String get displayValue => rating.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final effectiveFilledColor = starFilledColor ?? AppColors.starFilled;
    final effectiveEmptyColor = starEmptyColor ?? AppColors.starEmpty;
    final effectiveValueStyle = valueStyle ??
        TextStyle(
          color: AppColors.textSecondary,
          fontSize: size * 0.8,
          fontWeight: FontWeight.w600,
        );

    Widget starRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        IconData iconData;
        Color iconColor;

        if (rating >= starValue) {
          iconData = Icons.star;
          iconColor = effectiveFilledColor;
        } else if (rating >= starValue - halfStarThreshold) {
          iconData = Icons.star_half;
          iconColor = effectiveFilledColor;
        } else {
          iconData = Icons.star_border;
          iconColor = effectiveEmptyColor;
        }

        return Icon(
          iconData,
          size: size,
          color: iconColor,
        );
      }),
    );

    if (animate) {
      starRow = AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: starRow,
      );
    }

    if (showValue) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          starRow,
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: effectiveValueStyle,
          ),
        ],
      );
    }

    return starRow;
  }
}
