import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/gradient_button.dart';

void main() {
  group('GradientButton', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GradientButton(
              onPressed: null,
              child: Text('Continue'),
            ),
          ),
        ),
      );
      expect(find.text('Continue'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              onPressed: () => tapped = true,
              child: const Text('Go'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Go'));
      expect(tapped, isTrue);
    });

    testWidgets('does not fire when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GradientButton(
              onPressed: () => tapped = true,
              enabled: false,
              child: const Text('Off'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Off'));
      expect(tapped, isFalse);
    });
  });
}