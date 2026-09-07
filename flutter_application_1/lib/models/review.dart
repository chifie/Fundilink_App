/// A rating and review left by a customer for a fundi.
class Review {
  final String id;
  final String fundiId;
  final String customerName;
  final String? customerAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  /// Returns a short excerpt of the comment for list tiles.
  String get shortComment {
    if (comment.length <= 80) return comment;
    final trimmed = comment.substring(0, 77);
    final lastSpace = trimmed.lastIndexOf(' ');
    return '${trimmed.substring(0, lastSpace.clamp(0, trimmed.length))}...';
    }

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
