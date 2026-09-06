import 'package:flutter/material.dart';

import 'fundi_model.dart';

/// Additional helpers for the Fundi model.
extension FundiHelpers on Fundi {
  /// Returns true if the fundi has a portfolio.
  bool get hasPortfolio => portfolioImages.isNotEmpty;

  /// Returns true if the fundi has service tags.
  bool get hasServiceTags => serviceTags.isNotEmpty;

  /// Returns a display string for the starting price.
  String get priceDisplay => 'KES ${startingPrice.toStringAsFixed(0)}$priceUnit';

  /// Returns a short description (first 100 characters).
  String get shortDescription {
    if (description.length <= 100) return description;
    return '${description.substring(0, 97)}...';
  }

  /// Returns the rating as a formatted string.
  String get ratingDisplay => rating.toStringAsFixed(1);

  /// Returns true if the fundi is highly rated (4.5+).
  bool get isHighlyRated => rating >= 4.5;

  /// Returns a badge color for the fundi's rating tier.
  Color get ratingTierColor {
    if (rating >= 4.8) return const Color(0xFF7193A3);
    if (rating >= 4.5) return const Color(0xFF10B981);
    if (rating >= 4.0) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  /// Returns true if the fundi responds quickly (15 min or less).
  bool get isFastResponder => responseTimeMinutes <= 15;
}
