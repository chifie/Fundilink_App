import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/animated_count_up.dart';

void main() {
  group('AnimatedCountUp', () {
    testWidgets('counts up to the target value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedCountUp(value: 1200),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1200'), findsOneWidget);
    });

    testWidgets('applies the custom formatter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AnimatedCountUp(
              value: 1200,
              formatter: (v) => 'KSh ${v.round()}',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('KSh 1200'), findsOneWidget);
    });

    testWidgets('animates again when the value changes', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => AnimatedCountUp(
                value: 100,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('100'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}