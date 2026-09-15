import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/screens/profile_screen.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

import '../support/pump_app.dart';

void main() {
  testWidgets('shows identity and settings groups', (tester) async {
    await pumpWithStore(tester, const ProfileScreen());

    expect(find.text('Amina Yusuf'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('SUPPORT'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('theme toggle flips the store theme mode', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const ProfileScreen(), store: store);

    expect(store.themeMode, ThemeMode.light);

    await tester.tap(find.byIcon(Icons.brightness_6_outlined));
    await tester.pumpAndSettle();

    expect(store.themeMode, ThemeMode.dark);
  });
}
