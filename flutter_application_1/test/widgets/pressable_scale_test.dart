import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/pressable_scale.dart';

void main() {
  group('PressableScale', () {
    testWidgets('renders the child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PressableScale(child: Text('item')),
          ),
        ),
      );
      expect(find.text('item'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableScale(
              onTap: () => tapped = true,
              child: const Text('tap me'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('tap me'));
      expect(tapped, isTrue);
    });

    testWidgets('does not fire onTap when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PressableScale(
              onTap: () => tapped = true,
              enabled: false,
              child: const Text('no tap'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('no tap'));
      expect(tapped, isFalse);
    });
  });
}