import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fundilink_app/main.dart';

void main() {
  testWidgets('counter increments from the Material 3 button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('Increment'));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('light and dark Material 3 themes are applied',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final BuildContext initialContext =
        tester.element(find.byType(Scaffold).first);
    expect(Theme.of(initialContext).useMaterial3, isTrue);
    expect(Theme.of(initialContext).brightness, Brightness.light);

    await tester.tap(find.byIcon(Icons.brightness_6_outlined));
    // MaterialApp animates theme changes (AnimatedTheme), so settle first.
    await tester.pumpAndSettle();

    final BuildContext darkContext =
        tester.element(find.byType(Scaffold).first);
    expect(Theme.of(darkContext).brightness, Brightness.dark);
  });
}
