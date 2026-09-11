/// A fundi (service provider) listed on the marketplace.
class Fundi {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String categoryId;
  final String categoryName;
  final String description;
  final int experienceYears
  final String location;
  final String city;
  final double distanceKm;
  final double rating;
  final int ratingCount;
  final int completedJobs;
  final double startingPrice;
  final String priceUnit; // AppStrings.perHour or perJob
  final bool isAvailable;
  final bool verified;
  final int responseTimeMinutes;
  final List<String> serviceTags;
  final List<String> portfolioImages;

  /// Returns true if the fundi's profile image is a remote URL.
  bool get hasRemoteAvatar => avatarUrl != null && avatarUrl!.startsWith('http');

  /// Returns a short tagline built from the service tags.
  String get tagline {
    if (serviceTags.isEmpty) return '';
    return serviceTags.take(3).join(', ');
  }

  const Fundi({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.experienceYears,
    required this.location,
    required this.city,
    required this.distanceKm,
    required this.rating,
    required this.ratingCount,
    required this.completedJobs,
    required this.startingPrice,
    required this.priceUnit,
    required this.isAvailable,
    this.verified = false,
    this.responseTimeMinutes = 0,
    this.serviceTags = const [],
    this.portfolioImages = const [],
  });
}
