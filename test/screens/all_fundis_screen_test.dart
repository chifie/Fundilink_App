import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/screens/all_fundis_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';
import 'package:fundilink_app/widgets/fundi_card.dart';

import '../support/pump_app.dart';

void main() {
  Future<void> pumpCatalogue(
    WidgetTester tester, {
    FundiSkill? initialSkill,
    AppStore? store,
  }) async {
    await pumpWithStore(
      tester,
      AllFundisScreen(initialSkill: initialSkill),
      store: store ?? AppStore(storage: InMemoryKeyValueStore()),
    );
  }

  /// Name on the first card, which is the head of the current sort order.
  String firstCardName(WidgetTester tester) =>
      tester.widget<FundiCard>(find.byType(FundiCard).first).fundi.name;

  testWidgets('lists the catalogue sorted by rating', (tester) async {
    await pumpCatalogue(tester);

    expect(find.text('All fundis'), findsOneWidget);
    expect(firstCardName(tester), 'Grace Wanjiku');
  });

  testWidgets('an initial skill preselects the filter and titles the screen', (
    tester,
  ) async {
    await pumpCatalogue(tester, initialSkill: FundiSkill.plumbing);

    expect(find.text('Plumbing'), findsWidgets);
    expect(find.text('Joseph Kamau'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsNothing);
  });

  testWidgets('a filter chip narrows the list', (tester) async {
    await pumpCatalogue(tester);

    // Cards also label themselves with the service, so target the chip.
    await tester.tap(find.widgetWithText(FilterChip, 'Moving'));
    await tester.pumpAndSettle();

    expect(find.text('Mary Achieng'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'All'));
    await tester.pumpAndSettle();

    expect(find.text('Grace Wanjiku'), findsOneWidget);
  });

  testWidgets('sorting by price puts the cheapest first', (tester) async {
    await pumpCatalogue(tester);

    await tester.tap(find.byType(DropdownButton<FundiSort>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: low to high').last);
    await tester.pumpAndSettle();

    expect(firstCardName(tester), 'Grace Wanjiku');
  });

  testWidgets('sorting by price descending puts the dearest first', (
    tester,
  ) async {
    await pumpCatalogue(tester);

    await tester.tap(find.byType(DropdownButton<FundiSort>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Price: high to low').last);
    await tester.pumpAndSettle();

    expect(firstCardName(tester), 'Mary Achieng');
  });

  testWidgets('shows an empty state when a service has no fundis', (
    tester,
  ) async {
    const onlyCleaner = FundiProfile(
      name: 'Grace Wanjiku',
      skill: FundiSkill.cleaning,
      rating: 4.9,
      reviewCount: 132,
      jobsDone: 214,
      pricePerHour: 600,
      isOnline: true,
    );

    await pumpCatalogue(
      tester,
      initialSkill: FundiSkill.repairs,
      store: AppStore(
        fundis: const [onlyCleaner],
        storage: InMemoryKeyValueStore(),
      ),
    );

    expect(find.text('No fundis in this category'), findsOneWidget);
  });

  testWidgets('booking a fundi from the catalogue sends a request', (
    tester,
  ) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    await pumpCatalogue(tester, store: store);

    await tester.tap(find.text('Book').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();

    expect(store.bookings, hasLength(5));
    expect(store.bookings.first.fundi.name, 'Grace Wanjiku');
  });
}
