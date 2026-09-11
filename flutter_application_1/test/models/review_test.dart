import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/review.dart';

void main() {
  group('Review.shortComment', () {
    test('returns the full comment when it is short', () {
      final review = Review(
        id: 'rev1',
        fundiId: 'f1',
        customerName: 'Brian Kimani',
        rating: 5,
        comment: 'Great work!',
        createdAt: DateTime(2026, 9, 7),
      );
      expect(review.shortComment, 'Great work!');
    });

    test('truncates long comments with an ellipsis', () {
      final review = Review(
        id: 'rev2',
        fundiId: 'f1',
        customerName: 'Brian Kimani',
        rating: 4.5,
        comment:
            'This is a very long comment that should be truncated because '
            'it exceeds the eighty character limit for display in list tiles.',
        createdAt: DateTime(2026, 9, 7),
      );
      expect(review.shortComment.endsWith('...'), isTrue);
      expect(review.shortComment.length, lessThanOrEqualTo(80));
    });
  });
}
