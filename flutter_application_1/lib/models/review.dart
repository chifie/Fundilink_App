/// A rating and review left by a customer for a fundi.
class Review {
  final String id;
  final String fundiId;
  final String customerName;
  final String? customerAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.fundiId,
    required this.customerName,
    this.customerAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
