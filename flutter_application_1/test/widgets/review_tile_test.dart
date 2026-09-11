import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/models/review.dart';
import 'package:fundi_link/widgets/review_tile.dart';

void main() {
  group('ReviewTile', () {
    testWidgets('displays the reviewer name and stars', (tester) async {
      final review = Review(
        id: 'rev1',
        fundiId: 'f1',
        customerName: 'Brian Kimani',
        rating: 5,
        comment: 'Excellent work!',
        createdAt: DateTime(2026, 9, 7),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(
              review: review,
            ),
          ),
        ),
      );
      expect(find.text('Brian Kimani'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNWidgets(5));
    });

    testWidgets('shows the comment text', (tester) async {
      final review = Review(
        id: 'rev2',
        fundiId: 'f1',
        customerName: 'Brian Kimani',
        rating: 4.5,
        comment: 'Good job, arrived on time.',
        createdAt: DateTime(2026, 9, 7),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReviewTile(
              review: review,
            ),
          ),
        ),
      );
      expect(find.text('Good job, arrived on time.'), findsOneWidget);
    });
  });
}
