import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/screens/profile_screen.dart';
import 'package:fundilink_app/screens/saved_addresses_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

void main() {
  Future<AppStore> pumpAddresses(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const SavedAddressesScreen(), store: target);
    return target;
  }

  /// A store with no addresses left, to exercise the empty state.
  AppStore emptyStore() {
    return AppStore(storage: InMemoryKeyValueStore())
      ..removeAddress('address-home')
      ..removeAddress('address-office');
  }

  testWidgets('lists the saved addresses and marks the default', (
    tester,
  ) async {
    await pumpAddresses(tester);

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
  });

  testWidgets('tapping another address makes it the default', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    expect(store.defaultAddress?.label, 'Office');
  });

  testWidgets('removing an address drops it from the list', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.byTooltip('Remove Office'));
    await tester.pumpAndSettle();

    expect(find.text('Office'), findsNothing);
    expect(store.addresses, hasLength(1));
  });

  testWidgets('removing the default promotes the next address', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.byTooltip('Remove Home'));
    await tester.pumpAndSettle();

    expect(store.defaultAddress?.label, 'Office');
    expect(find.text('Default'), findsOneWidget);
  });

  testWidgets('adds an address through the dialog', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Label'), 'Gym');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Address'),
      'Sarit Centre, Westlands',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(store.addresses, hasLength(3));
    expect(find.text('Gym'), findsOneWidget);
    expect(store.defaultAddress?.label, 'Home');
  });

  testWidgets('the dialog refuses an unnamed address', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Address'),
      'Sarit Centre, Westlands',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Name this address'), findsOneWidget);
    expect(store.addresses, hasLength(2));
  });

  testWidgets('a cancelled dialog adds nothing', (tester) async {
    final store = await pumpAddresses(tester);

    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(store.addresses, hasLength(2));
  });

  testWidgets('shows an empty state with no addresses', (tester) async {
    await pumpAddresses(tester, store: emptyStore());

    expect(find.text('No saved addresses'), findsOneWidget);
  });

  testWidgets('a new address becomes the default when the list is empty', (
    tester,
  ) async {
    final store = await pumpAddresses(tester, store: emptyStore());

    await tester.tap(find.text('Add address'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Label'), 'Home');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Address'),
      'Riverside Drive, Nairobi',
    );
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(store.defaultAddress?.label, 'Home');
  });

  testWidgets('is reachable from the profile settings', (tester) async {
    await pumpWithStore(tester, const ProfileScreen());

    await tester.tap(find.text('Saved addresses'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
  });
}
