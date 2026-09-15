import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/main.dart';
import 'package:fundilink_app/screens/new_request_sheet.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(store: AppStore(storage: InMemoryKeyValueStore())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('home tab renders the clean Material 3 landing', (tester) async {
    await pumpApp(tester);

    expect(find.text('Find a trusted fundi'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('New request'), findsOneWidget);
  });

  testWidgets('bottom navigation switches tabs', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();
    expect(find.text('My bookings'), findsOneWidget);

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    expect(find.text('Messages'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Edit profile'), findsOneWidget);
  });

  testWidgets('light and dark Material 3 themes are applied', (tester) async {
    await pumpApp(tester);

    final BuildContext initialContext = tester.element(
      find.byType(Scaffold).first,
    );
    expect(Theme.of(initialContext).useMaterial3, isTrue);
    expect(Theme.of(initialContext).brightness, Brightness.light);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.brightness_6_outlined));
    await tester.pumpAndSettle();

    final BuildContext darkContext = tester.element(
      find.byType(Scaffold).first,
    );
    expect(Theme.of(darkContext).brightness, Brightness.dark);
  });

  testWidgets('new request FAB opens the request sheet', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('New request'));
    await tester.pumpAndSettle();

    expect(find.text('Pick a service and describe the job.'), findsOneWidget);
    expect(find.text('Send request'), findsOneWidget);
  });

  testWidgets('a request made from the FAB reaches the bookings tab', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('New request'));
    await tester.pumpAndSettle();
    // The home tab keeps its search field behind the sheet, so target the
    // sheet's own description field.
    await tester.enterText(
      find.byKey(const Key('request-description-field')),
      'Repair the gate hinge',
    );
    // The category grid behind the sheet also offers "Repairs".
    await tester.tap(
      find.descendant(
        of: find.byType(NewRequestSheet),
        matching: find.text('Repairs'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send request'));
    await tester.pumpAndSettle();

    expect(find.text('Request sent to Faith Njeri'), findsOneWidget);

    await tester.tap(find.text('Bookings'));
    await tester.pumpAndSettle();

    expect(find.text('Repair the gate hinge'), findsOneWidget);
  });

  testWidgets('a sent message updates the chats tab preview', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Chats'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Grace Wanjiku'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Karibu!');
    await tester.tap(find.byIcon(Icons.send_outlined));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Karibu!'), findsOneWidget);
  });
}
