import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/widgets/fundi_avatar.dart';
import 'package:fundilink_app/widgets/status_badge.dart';

void main() {
  group('FundiAvatar', () {
    testWidgets('shows initials of the name', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FundiAvatar(name: 'Grace Wanjiku')),
        ),
      );

      expect(find.text('GW'), findsOneWidget);
    });

    testWidgets('shows online dot when online', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FundiAvatar(name: 'Grace Wanjiku', isOnline: true),
          ),
        ),
      );

      expect(find.byKey(const Key('fundi-online-dot')), findsOneWidget);
    });

    testWidgets('hides online dot when offline', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FundiAvatar(name: 'Grace Wanjiku')),
        ),
      );

      expect(find.byKey(const Key('fundi-online-dot')), findsNothing);
    });
  });

  group('StatusBadge', () {
    testWidgets('renders label for each status', (tester) async {
      Widget wrap(BookingStatus status) => MaterialApp(
        home: Scaffold(body: StatusBadge(status: status)),
      );

      await tester.pumpWidget(wrap(BookingStatus.active));
      expect(find.text('Active'), findsOneWidget);

      await tester.pumpWidget(wrap(BookingStatus.completed));
      expect(find.text('Completed'), findsOneWidget);

      await tester.pumpWidget(wrap(BookingStatus.cancelled));
      expect(find.text('Cancelled'), findsOneWidget);
    });
  });
}
