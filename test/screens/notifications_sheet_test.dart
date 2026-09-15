import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/notification.dart';
import 'package:fundilink_app/screens/notifications_sheet.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

/// Opens the sheet the way the home tab does, so the rows get the sheet's
/// own Material ancestor.
class _SheetHost extends StatelessWidget {
  const _SheetHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showNotificationsSheet(context),
          child: const Text('Open notifications'),
        ),
      ),
    );
  }
}

void main() {
  Future<AppStore> pumpSheet(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const _SheetHost(), store: target);
    await tester.tap(find.text('Open notifications'));
    await tester.pumpAndSettle();
    return target;
  }

  testWidgets('lists unread messages and booking updates', (tester) async {
    await pumpSheet(tester);

    expect(find.text('Grace Wanjiku sent you a message'), findsOneWidget);
    expect(find.text('Faith Njeri sent you a message'), findsOneWidget);
    expect(find.text('Grace Wanjiku is on the way'), findsOneWidget);
    expect(find.text('Joseph Kamau finished your job'), findsOneWidget);
    expect(find.byKey(const Key('notification-unread-dot')), findsNWidgets(2));
  });

  testWidgets('nothing to report shows an empty state', (tester) async {
    await pumpSheet(
      tester,
      store: AppStore(
        conversations: const [],
        bookings: const [],
        storage: InMemoryKeyValueStore(),
      ),
    );

    expect(find.text('Nothing new'), findsOneWidget);
    expect(find.byKey(const Key('notification-unread-dot')), findsNothing);
  });

  testWidgets('tapping a message notification opens that chat', (tester) async {
    await pumpSheet(tester);

    await tester.tap(find.text('Grace Wanjiku sent you a message'));
    await tester.pumpAndSettle();

    expect(find.text('Hello! Are you available tomorrow?'), findsOneWidget);
    expect(find.text('Type a message'), findsOneWidget);
  });

  testWidgets('booking rows have nothing to open', (tester) async {
    final store = await pumpSheet(tester);

    final bookingRow = tester.widget<ListTile>(
      find.ancestor(
        of: find.text(
          '${store.bookings.first.service} · '
          '${store.bookings.first.dateLabel}',
        ),
        matching: find.byType(ListTile),
      ),
    );

    expect(bookingRow.onTap, isNull);
    expect(bookingRow.trailing, isNull);
  });

  testWidgets('unread items come first', (tester) async {
    await pumpSheet(tester);

    final titles = tester
        .widgetList<ListTile>(find.byType(ListTile))
        .map((tile) => (tile.title! as Text).data)
        .toList();

    expect(
      titles.takeWhile((title) => title!.contains('sent you a message')),
      hasLength(2),
    );
  });

  testWidgets('kind icons describe the activity', (tester) async {
    await pumpSheet(tester);

    expect(find.byIcon(NotificationKind.message.icon), findsNWidgets(2));
    expect(find.byIcon(NotificationKind.completed.icon), findsOneWidget);
  });
}
