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

  bool get isLoading => _loading;

  List<Review> reviewsFor(String fundiId) =>
      _byFundi[fundiId] ?? const [];

  Future<void> loadReviews(String fundiId) async {
    _loading = true;
    notifyListeners();
    _byFundi[fundiId] = await _repository.getReviewsForFundi(fundiId);
    _loading = false;
    notifyListeners();
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