import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/screens/bookings_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

void main() {
  Future<AppStore> pumpBookings(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const BookingsScreen(), store: target);
    return target;
  }

  testWidgets('active filter shows in-progress bookings only', (tester) async {
    await pumpBookings(tester);

    expect(find.text('Deep house cleaning'), findsOneWidget);
    expect(find.text('Leaking sink repair'), findsNothing);
    expect(find.text('Move furniture to Kilimani'), findsNothing);
  });

  testWidgets('switching to Done shows completed bookings', (tester) async {
    await pumpBookings(tester);

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();

    expect(find.text('Leaking sink repair'), findsOneWidget);
    expect(find.text('Deep house cleaning'), findsNothing);
  });

  testWidgets('switching to Cancelled shows cancelled bookings', (
    tester,
  ) async {
    await pumpBookings(tester);

    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();

    expect(find.text('Move furniture to Kilimani'), findsOneWidget);
    expect(find.text('Deep house cleaning'), findsNothing);
  });

  testWidgets('cancelling asks for confirmation first', (tester) async {
    final store = await pumpBookings(tester);

    // Both active bookings offer a cancel button; the first is b1.
    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    expect(find.text('Cancel this booking?'), findsOneWidget);
    expect(store.bookingsWithStatus(BookingStatus.active), hasLength(2));

    await tester.tap(find.text('Cancel booking'));
    await tester.pumpAndSettle();

    expect(store.bookingsWithStatus(BookingStatus.active), hasLength(1));
    expect(find.text('Deep house cleaning cancelled'), findsOneWidget);
  });

  testWidgets('keeping a booking leaves it active', (tester) async {
    final store = await pumpBookings(tester);

    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();

    expect(store.bookingsWithStatus(BookingStatus.active), hasLength(2));
    expect(find.text('Deep house cleaning'), findsOneWidget);
  });

  testWidgets('a cancelled booking moves to the Cancelled filter', (
    tester,
  ) async {
    await pumpBookings(tester);

    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel booking'));
    await tester.pumpAndSettle();

    expect(find.text('Deep house cleaning'), findsNothing);

    await tester.tap(find.text('Cancelled'));
    await tester.pumpAndSettle();

    expect(find.text('Deep house cleaning'), findsOneWidget);
  });

  testWidgets('rebooking a finished job opens the fundi sheet', (tester) async {
    await pumpBookings(tester);

    await tester.tap(find.byIcon(Icons.check_circle_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rebook'));
    await tester.pumpAndSettle();

    expect(find.text('Book now'), findsOneWidget);
    expect(find.text('Joseph Kamau'), findsWidgets);
  });
}
