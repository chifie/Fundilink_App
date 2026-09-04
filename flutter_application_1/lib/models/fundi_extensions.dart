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

  /// Returns true if the fundi responds quickly (15 min or less).
  bool get isFastResponder => responseTimeMinutes <= 15;
}
