import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/price_tag.dart';
import 'package:fundi_link/widgets/verified_badge.dart';

void main() {
  group('PriceTag', () {
    testWidgets('renders the price text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PriceTag(price: 'KES 800/job')),
        ),
      );
      expect(find.text('KES 800/job'), findsOneWidget);
    });

    testWidgets('renders the compact variant without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PriceTag(price: 'KES 500', compact: true)),
        ),
      );
      expect(find.text('KES 500'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('VerifiedBadge', () {
    testWidgets('renders the verified icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: VerifiedBadge())),
      );
      expect(find.byIcon(Icons.verified), findsOneWidget);
    });
  });
}