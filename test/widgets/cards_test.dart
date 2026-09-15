import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/widgets/booking_card.dart';
import 'package:fundilink_app/widgets/empty_state.dart';
import 'package:fundilink_app/widgets/fundi_card.dart';

FundiProfile _fundi() => const FundiProfile(
  name: 'Grace Wanjiku',
  skill: FundiSkill.cleaning,
  rating: 4.9,
  reviewCount: 132,
  jobsDone: 214,
  pricePerHour: 600,
  isOnline: true,
);

void main() {
  group('FundiCard', () {
    testWidgets('shows name, skill, rating and price', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FundiCard(fundi: _fundi())),
        ),
      );

      expect(find.text('Grace Wanjiku'), findsOneWidget);
      expect(find.text('Cleaning'), findsOneWidget);
      expect(find.text('4.9 (132)'), findsOneWidget);
      expect(find.text('KSh 600'), findsOneWidget);
    });
  });

  group('BookingCard', () {
    testWidgets('active booking shows progress tracker and cancel', (
      tester,
    ) async {
      final booking = Booking(
        id: 'b1',
        fundi: _fundi(),
        service: 'Deep house cleaning',
        scheduledAt: DateTime(2026, 9, 20, 14),
        price: 1800,
        status: BookingStatus.active,
        step: RequestStep.inProgress,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BookingCard(booking: booking)),
        ),
      );

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('In progress'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('KSh 1,800'), findsOneWidget);
    });

    testWidgets('completed booking offers rebook without tracker', (
      tester,
    ) async {
      final booking = Booking(
        id: 'b3',
        fundi: _fundi(),
        service: 'Leaking sink repair',
        scheduledAt: DateTime(2026, 9, 5, 11),
        price: 1200,
        status: BookingStatus.completed,
        step: RequestStep.done,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BookingCard(booking: booking)),
        ),
      );

      expect(find.text('Rebook'), findsOneWidget);
      expect(find.text('In progress'), findsNothing);
    });
  });

  group('EmptyState', () {
    testWidgets('shows title, message and optional action', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox_outlined,
              title: 'Nothing here yet',
              message: 'Book a fundi to get started.',
              actionLabel: 'Explore',
              onAction: () {},
            ),
          ),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Book a fundi to get started.'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });
  });
}
