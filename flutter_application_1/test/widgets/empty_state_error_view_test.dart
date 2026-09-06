import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/widgets/empty_state.dart';
import 'package:fundi_link/widgets/error_view.dart';

void main() {
  group('EmptyState', () {
    testWidgets('renders icon, title and message', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.inbox_outlined,
              title: 'Nothing here',
              message: 'It will appear once there is content.',
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('It will appear once there is content.'), findsOneWidget);
    });

    testWidgets('fires the action when the button is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyState(
              icon: Icons.search_off,
              title: 'No results',
              actionLabel: AppStrings.retry,
              onAction: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.text(AppStrings.retry));
      expect(tapped, isTrue);
    });
  });

  group('ErrorView', () {
    testWidgets('shows the default message when none is given', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ErrorView(onRetry: () {})),
        ),
      );
      expect(find.text(AppStrings.somethingWentWrong), findsOneWidget);
      expect(find.text(AppStrings.retry), findsOneWidget);
    });

    testWidgets('shows a custom message and fires retry', (tester) async {
      var retried = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorView(
              message: 'Network error',
              onRetry: () => retried = true,
            ),
          ),
        ),
      );

      expect(find.text('Network error'), findsOneWidget);
      await tester.tap(find.text(AppStrings.retry));
      expect(retried, isTrue);
    });
  });
}