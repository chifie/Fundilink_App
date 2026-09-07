import 'package:flutter/foundation.dart';

import '../models/review.dart';
import '../repositories/review_repository.dart';

/// Manages ratings and reviews, cached per fundi.
class ReviewProvider extends ChangeNotifier {
  ReviewProvider({ReviewRepository? repository})
    : _repository = repository ?? ReviewRepository();

  final ReviewRepository _repository;

  final Map<String, List<Review>> _byFundi = {};
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get error => _error;

  List<Review> reviewsFor(String fundiId) => _byFundi[fundiId] ?? const [];

  /// Average rating across the cached reviews for a fundi (0 when none).
  double averageFor(String fundiId) {
    final reviews = _byFundi[fundiId];
    if (reviews == null || reviews.isEmpty) return 0;
    return reviews.fold<double>(0, (sum, r) => sum + r.rating) / reviews.length;
  }

  Future<void> loadReviews(String fundiId) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _byFundi[fundiId] = await _repository.getReviewsForFundi(fundiId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addReview({
    required String fundiId,
    required String customerName,
    String? customerAvatar,
    required double rating,
    required String comment,
  }) async {
    final review = await _repository.addReview(
      fundiId: fundiId,
      customerName: customerName,
      customerAvatar: customerAvatar,
      rating: rating,
      comment: comment,
    );
    final list = _byFundi.putIfAbsent(fundiId, () => []);
    list.insert(0, review);
    notifyListeners();
  }
}
