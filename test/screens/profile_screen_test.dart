import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/screens/profile_screen.dart';

void _noop() {}

void main() {
  testWidgets('shows identity and settings groups', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ProfileScreen(onToggleTheme: _noop)),
    );

    expect(find.text('Amina Yusuf'), findsOneWidget);
    expect(find.text('ACCOUNT'), findsOneWidget);
    expect(find.text('PREFERENCES'), findsOneWidget);
    expect(find.text('SUPPORT'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('theme toggle triggers callback', (tester) async {
    var toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ProfileScreen(
          onToggleTheme: () => toggled = true,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.brightness_6_outlined));
    expect(toggled, isTrue);
  });
}
