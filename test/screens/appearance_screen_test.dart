import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/screens/appearance_screen.dart';
import 'package:fundilink_app/screens/profile_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('lists every scheme option', (tester) async {
    await pumpWithStore(tester, const AppearanceScreen());

    for (final option in AppearanceScreen.options) {
      expect(find.text(option.label), findsOneWidget);
      expect(find.text(option.detail), findsOneWidget);
    }
  });

  testWidgets('checks the scheme the store is currently using', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore())
      ..setThemeMode(ThemeMode.dark);
    await pumpWithStore(tester, const AppearanceScreen(), store: store);

    final darkTile = tester.widget<ListTile>(
      find.ancestor(of: find.text('Dark'), matching: find.byType(ListTile)),
    );

    expect(darkTile.selected, isTrue);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('tapping an option updates the store', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const AppearanceScreen(), store: store);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();

    expect(store.themeMode, ThemeMode.system);
  });

  testWidgets('is reachable from the profile settings', (tester) async {
    await pumpWithStore(tester, const ProfileScreen());

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();

    expect(find.text('System default'), findsOneWidget);
  });
}
