import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/empty_state.dart';

void main() {
  group('EmptyState', () {
    testWidgets('shows the icon and title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.search_off,
              title: 'No results found',
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.search_off), findsOneWidget);
      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('shows the message when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.search_off,
              title: 'No results found',
              message: 'Try a different search term.',
            ),
          ),
        ),
      );
      expect(find.text('Try a different search term.'), findsOneWidget);
    });

    testWidgets('shows the action button when an action is provided', (tester) async {
      bool buttonTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.search_off,
              title: 'No results found',
              message: 'Try a different search term.',
              actionLabel: 'Search again',
              onAction: () => buttonTapped = true,
            ),
          ),
        ),
      );
      expect(find.text('Search again'), findsOneWidget);
      await tester.tap(find.text('Search again'));
      expect(buttonTapped, isTrue);
    });
  });
}
