import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/fundi_avatar.dart';

void main() {
  Widget wrap(FundiAvatar avatar) => MaterialApp(home: Scaffold(body: avatar));

  group('FundiAvatar', () {
    testWidgets('shows initials from a full name when there is no photo', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(FundiAvatar(name: 'James Otieno')));

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('JO'), findsOneWidget);
    });

    testWidgets('single names use their first letter in uppercase', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(FundiAvatar(name: 'ana')));

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('empty names fall back to a question mark', (tester) async {
      await tester.pumpWidget(wrap(FundiAvatar(name: '')));

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('renders initials when an image URL is present', (
      tester,
    ) async {
      // No HTTP client exists in the test binding, so the avatar must fall
      // back to its initials instead of throwing.
      await tester.pumpWidget(
        wrap(
          FundiAvatar(
            name: 'Mary Wanjiku',
            imageUrl: 'https://x.invalid/a.png',
          ),
        ),
      );

      expect(find.text('MW'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
