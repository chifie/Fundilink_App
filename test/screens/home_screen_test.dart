import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/screens/home_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';
import 'package:fundilink_app/widgets/search_bar_field.dart';

import '../support/pump_app.dart';

void main() {
  Future<AppStore> pumpHome(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const HomeScreen(), store: target);
    return target;
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

  testWidgets('the bell shows how many notifications are unread', (
    tester,
  ) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    await pumpHome(tester, store: store);

    expect(store.unreadNotificationCount, 2);
    expect(
      find.descendant(of: find.byType(Badge), matching: find.text('2')),
      findsOneWidget,
    );
  });

  testWidgets('the bell opens the notifications sheet', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byIcon(Icons.notifications_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Grace Wanjiku sent you a message'), findsOneWidget);
  });

  testWidgets('pulling down re-checks the catalogue', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    var notified = 0;
    store.addListener(() => notified++);
    await pumpHome(tester, store: store);
    notified = 0;

    expect(find.byType(RefreshIndicator), findsOneWidget);

    await tester.fling(find.byType(ListView).first, const Offset(0, 400), 1200);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(notified, greaterThan(0));
  });

  testWidgets('a category tile opens the catalogue filtered by service', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.text('Plumbing'));
    await tester.pumpAndSettle();

    expect(find.text('Joseph Kamau'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsNothing);
  });

  testWidgets('see all opens the unfiltered catalogue', (tester) async {
    await pumpHome(tester);

    await scrollDown(tester, find.text('Top rated fundis'));
    await tester.tap(find.text('See all'));
    await tester.pumpAndSettle();

    expect(find.text('All fundis'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsOneWidget);
    expect(find.text('Mary Achieng'), findsOneWidget);
  });

  testWidgets('a search result opens that fundi\'s detail sheet', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byType(SearchBarField));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'joseph');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Book'));
    await tester.pumpAndSettle();

    expect(find.text('Book now'), findsOneWidget);
    expect(find.text('Joseph Kamau'), findsWidgets);
  });

  testWidgets('book action opens detail sheet and sends request', (
    tester,
  ) async {
    final store = await pumpHome(tester);
    final before = store.bookings.length;

    await scrollDown(tester, find.text('Book'));
    await tester.tap(find.text('Book').first);
    await tester.pumpAndSettle();
    expect(find.text('Book now'), findsOneWidget);

    await tester.tap(find.text('Book now'));
    await tester.pumpAndSettle();

    expect(find.text('Request sent to Grace Wanjiku'), findsOneWidget);
    expect(store.bookings, hasLength(before + 1));

    final requested = store.bookings.first;
    expect(requested.fundi.name, 'Grace Wanjiku');
    expect(requested.service, 'Cleaning job');
    expect(requested.price, 600);
    expect(requested.status, BookingStatus.active);
    expect(requested.step, RequestStep.requested);
  });
}
