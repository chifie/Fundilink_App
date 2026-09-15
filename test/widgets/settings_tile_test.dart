import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/widgets/settings_tile.dart';

void main() {
  Future<void> pumpGroup(WidgetTester tester, List<SettingsTile> tiles) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SettingsGroup(title: 'Account', tiles: tiles),
        ),
      ),
    );
  }

  testWidgets('uppercases the group title', (tester) async {
    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.person_outline,
        label: 'Edit profile',
        onTap: () {},
      ),
    ]);

    expect(find.text('ACCOUNT'), findsOneWidget);
  });

  testWidgets('separates tiles but not after the last one', (tester) async {
    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.person_outline,
        label: 'Edit profile',
        onTap: () {},
      ),
      SettingsTile(
        icon: Icons.location_on_outlined,
        label: 'Saved addresses',
        onTap: () {},
      ),
      SettingsTile(
        icon: Icons.payments_outlined,
        label: 'Payment methods',
        onTap: () {},
      ),
    ]);

    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('a single tile needs no divider', (tester) async {
    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.person_outline,
        label: 'Edit profile',
        onTap: () {},
      ),
    ]);

    expect(find.byType(Divider), findsNothing);
  });

  testWidgets('tap fires the callback', (tester) async {
    var tapped = 0;

    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.person_outline,
        label: 'Edit profile',
        onTap: () => tapped++,
      ),
    ]);
    await tester.tap(find.text('Edit profile'));

    expect(tapped, 1);
  });

  testWidgets('destructive tiles use the error colour', (tester) async {
    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.logout,
        label: 'Sign out',
        destructive: true,
        onTap: () {},
      ),
    ]);

    final context = tester.element(find.text('Sign out'));
    expect(
      tester.widget<Icon>(find.byIcon(Icons.logout)).color,
      Theme.of(context).colorScheme.error,
    );
  });

  testWidgets('trailing replaces the default chevron', (tester) async {
    await pumpGroup(tester, [
      SettingsTile(
        icon: Icons.dark_mode_outlined,
        label: 'Appearance',
        trailing: const Text('Off'),
        onTap: () {},
      ),
    ]);

    expect(find.text('Off'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });
}
