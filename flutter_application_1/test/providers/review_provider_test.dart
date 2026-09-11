import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/providers/review_provider.dart';

void main() {
  group('ReviewProvider loading', () {
    test('loadReviews caches reviews per fundi', () async {
      final provider = ReviewProvider();
      await provider.loadReviews('f1');

      expect(provider.reviewsFor('f1'), isNotEmpty);
      expect(provider.reviewsFor('f1').every((r) => r.fundiId == 'f1'), isTrue);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('averageFor computes the cached average rating', () async {
      final provider = ReviewProvider();
      await provider.loadReviews('f1');

      // Seed reviews for f1 are 5.0, 4.5 and 5.0.
      expect(provider.averageFor('f1'), closeTo(4.83, 0.01));
    });

    test('averageFor returns zero when there are no reviews', () async {
      final provider = ReviewProvider();
      expect(provider.averageFor('no-such-fundi'), 0);
    });
  });

  group('ReviewProvider adding', () {
    test('addReview prepends and moves the average', () async {
      final provider = ReviewProvider();
      await provider.loadReviews('f1');
      final before = provider.averageFor('f1');

      await provider.addReview(
        fundiId: 'f1',
        customerName: 'New Customer',
        rating: 1,
        comment: 'Not great.',
      );

      expect(provider.reviewsFor('f1').first.customerName, 'New Customer');
      expect(provider.reviewsFor('f1').first.rating, 1);
      expect(provider.averageFor('f1'), lessThan(before));
    });
  });
}
