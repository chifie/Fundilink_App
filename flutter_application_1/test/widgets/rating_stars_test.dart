import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/rating_stars.dart';

Widget _wrap({required double rating, bool showValue = false}) {
  return MaterialApp(
    home: Scaffold(
      body: RatingStars(rating: rating, showValue: showValue),
    ),
  );
}

void main() {
  testWidgets('renders five filled stars for a perfect rating', (tester) async {
    await tester.pumpWidget(_wrap(rating: 5));
    expect(find.byIcon(Icons.star), findsNWidgets(5));
    expect(find.byIcon(Icons.star_half), findsNothing);
    expect(find.byIcon(Icons.star_border), findsNothing);
  });

  testWidgets('renders a half star for fractional ratings', (tester) async {
    await tester.pumpWidget(_wrap(rating: 4.5));
    expect(find.byIcon(Icons.star), findsNWidgets(4));
    expect(find.byIcon(Icons.star_half), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsNothing);
  });

  testWidgets('renders empty stars for a low rating', (tester) async {
    await tester.pumpWidget(_wrap(rating: 2));
    expect(find.byIcon(Icons.star), findsNWidgets(2));
    expect(find.byIcon(Icons.star_border), findsNWidgets(3));
  });

  testWidgets('showValue displays the numeric rating', (tester) async {
    await tester.pumpWidget(_wrap(rating: 4.8, showValue: true));
    expect(find.text('4.8'), findsOneWidget);
  });
}
