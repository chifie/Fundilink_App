import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/screens/new_request_sheet.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

/// Opens the sheet the way the shell does, so popping it is a real
/// navigation rather than popping the only route.
class _SheetHost extends StatelessWidget {
  const _SheetHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const NewRequestSheet(),
          ),
          child: const Text('Open sheet'),
        ),
      ),
    );
  }
}

void main() {
  Future<AppStore> pumpSheet(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const _SheetHost(), store: target);
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    return target;
  }

  Future<void> chooseService(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  Future<void> describeJob(WidgetTester tester, String description) async {
    await tester.enterText(
      find.byKey(const Key('request-description-field')),
      description,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('cannot send until a service is chosen', (tester) async {
    await pumpSheet(tester);

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Send request'),
    );

    expect(button.onPressed, isNull);
    expect(find.text('Choose a service to continue.'), findsOneWidget);
  });

  testWidgets('requires a description', (tester) async {
    final store = await pumpSheet(tester);

    await chooseService(tester, 'Cleaning');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    expect(find.text('Describe the job so fundis can quote'), findsOneWidget);
    expect(store.bookings.first.id, 'b1', reason: 'nothing was created');
  });

  testWidgets('creates a booking and matches the best-rated fundi', (
    tester,
  ) async {
    final store = await pumpSheet(tester);

    await chooseService(tester, 'Cleaning');
    await describeJob(tester, 'Deep clean the kitchen');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    final created = store.bookings.first;
    expect(created.service, 'Deep clean the kitchen');
    expect(created.fundi.name, 'Grace Wanjiku');
    expect(created.price, 600);
    expect(created.status, BookingStatus.pending);
    expect(created.step, RequestStep.requested);
    expect(find.text('Request sent to Grace Wanjiku'), findsOneWidget);
  });

  testWidgets('schedules the request for tomorrow morning by default', (
    tester,
  ) async {
    final store = await pumpSheet(tester);

    await chooseService(tester, 'Cleaning');
    await describeJob(tester, 'Deep clean the kitchen');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    final scheduledAt = store.bookings.first.scheduledAt;
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    expect(scheduledAt.hour, 9);
    expect(scheduledAt.day, tomorrow.day);
    expect(scheduledAt.month, tomorrow.month);
  });

  testWidgets('trims the description before saving it', (tester) async {
    final store = await pumpSheet(tester);

    await chooseService(tester, 'Plumbing');
    await describeJob(tester, '   Fix the leaking sink   ');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    expect(store.bookings.first.service, 'Fix the leaking sink');
  });

  testWidgets('reports when no fundi offers the service', (tester) async {
    const onlyCleaner = FundiProfile(
      name: 'Grace Wanjiku',
      skill: FundiSkill.cleaning,
      rating: 4.9,
      reviewCount: 132,
      jobsDone: 214,
      pricePerHour: 600,
      isOnline: true,
    );
    final store = await pumpSheet(
      tester,
      store: AppStore(
        fundis: const [onlyCleaner],
        storage: InMemoryKeyValueStore(),
      ),
    );
    final before = store.bookings.length;

    await chooseService(tester, 'Electrical');
    await describeJob(tester, 'Fix the kitchen wiring');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    expect(find.text('No fundis available for electrical yet'), findsOneWidget);
    expect(store.bookings, hasLength(before));
  });

  testWidgets('clears the description error once typing resumes', (
    tester,
  ) async {
    await pumpSheet(tester);

    await chooseService(tester, 'Cleaning');
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();
    expect(find.text('Describe the job so fundis can quote'), findsOneWidget);

    await describeJob(tester, 'Deep clean the kitchen');

    expect(find.text('Describe the job so fundis can quote'), findsNothing);
  });
}
