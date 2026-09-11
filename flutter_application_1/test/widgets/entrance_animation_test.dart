import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/entrance_animation.dart';

void main() {
  group('EntranceAnimation', () {
    testWidgets('renders the child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EntranceAnimation(
              animate: false,
              child: Text('hello'),
            ),
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('animates the child in when enabled', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EntranceAnimation(child: Text('hello')),
          ),
        ),
      );
      // The fade starts below full opacity on the first frame.
      final opacity = tester.widget<FadeTransition>(
        find
            .ancestor(
              of: find.text('hello'),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(opacity.opacity.value, lessThan(1.0));

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('honours the delay before starting', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EntranceAnimation(
              delay: Duration(milliseconds: 500),
              child: Text('late'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('late'), findsOneWidget);
      // Advance past the delay so the pending timer fires.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}