import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/screens/bookings_screen.dart';

import '../support/pump_app.dart';

void main() {
  Future<void> pumpBookings(WidgetTester tester) async {
    await pumpWithStore(tester, const BookingsScreen());
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
}
