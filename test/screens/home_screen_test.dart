import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/screens/home_screen.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
  }

  Future<void> scrollDown(WidgetTester tester, Finder finder) async {
    // The grid and the list both own Scrollables, so drag the ListView
    // directly instead of using scrollUntilVisible.
    for (var i = 0; i < 10 && finder.evaluate().isEmpty; i++) {
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
  }

  testWidgets('shows greeting, search and categories', (tester) async {
    await pumpHome(tester);

    expect(find.text('Find a trusted fundi'), findsOneWidget);
    expect(find.text('Search services or fundis'), findsOneWidget);
    for (final skill in FundiSkill.values) {
      expect(find.text(skill.label), findsOneWidget);
    }
  });

  testWidgets('shows promo banner and top rated fundis', (tester) async {
    await pumpHome(tester);

    expect(find.text('Get 20% off your first fundi request.'), findsOneWidget);

    await scrollDown(tester, find.text('Top rated fundis'));
    expect(find.text('Grace Wanjiku'), findsOneWidget);
  });

  testWidgets('book action opens detail sheet and sends request', (
    tester,
  ) async {
    await pumpHome(tester);

    await scrollDown(tester, find.text('Book'));
    await tester.tap(find.text('Book').first);
    await tester.pumpAndSettle();
    expect(find.text('Book now'), findsOneWidget);

    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();
    expect(find.text('Request sent to Grace Wanjiku'), findsOneWidget);
  });
}
