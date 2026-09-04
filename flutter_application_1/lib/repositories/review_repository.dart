import 'package:uuid/uuid.dart';

import '../data/mock_data.dart';
import '../models/review.dart';

/// Data source for fundi ratings and reviews.
class ReviewRepository {
  static const Duration _latency = Duration(milliseconds: 400);

  static const _uuid = Uuid();

  Future<List<Review>> getReviewsForFundi(String fundiId) async {
    await Future<void>.delayed(_latency);
    final list = MockData.reviewsForFundi(fundiId);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Future<Review> addReview({
    required String fundiId,
    required String customerName,
    String? customerAvatar,
    required double rating,
    required String comment,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final review = Review(
      id: _uuid.v4(),
      fundiId: fundiId,
      customerName: customerName,
      customerAvatar: customerAvatar,
      rating: rating,
      comment: comment,
      createdAt: DateTime.now(),
    );
    MockData.reviews.insert(0, review);
    return review;
  }
}