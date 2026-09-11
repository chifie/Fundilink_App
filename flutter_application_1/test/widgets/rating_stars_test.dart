import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/rating_stars.dart';

void main() {
  group('RatingStars', () {
    testWidgets('renders five stars for a 5 star rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(
              rating: 5.0,
              size: 16,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsNWidgets(5));
      expect(find.byIcon(Icons.star_half), findsNothing);
      expect(find.byIcon(Icons.star_border), findsNothing);
    });

    testWidgets('renders partial stars for a 4.5 rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(
              rating: 4.5,
              size: 16,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsNWidgets(4));
      expect(find.byIcon(Icons.star_half), findsOneWidget);
    });

    testWidgets('renders empty stars for a 2 star rating', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(
              rating: 2.0,
              size: 16,
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.star), findsNWidgets(2));
      expect(find.byIcon(Icons.star_border), findsNWidgets(3));
    });

    testWidgets('shows the numeric value when showValue is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RatingStars(
              rating: 4.5,
              size: 16,
              showValue: true,
            ),
          ),
        ),
      );
      expect(find.text('4.5'), findsOneWidget);
    });
  });
}
