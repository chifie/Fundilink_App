import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/info_row.dart';
import 'package:fundi_link/widgets/section_header.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SectionHeader(title: 'Recommended Fundis')),
        ),
      );
      expect(find.text('Recommended Fundis'), findsOneWidget);
    });

    testWidgets('renders and fires the trailing action', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionHeader(
              title: 'Categories',
              actionLabel: 'View All',
              onActionTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('View All'), findsOneWidget);
      await tester.tap(find.text('View All'));
      expect(tapped, isTrue);
    });
  });

  group('InfoRow', () {
    testWidgets('renders the icon and text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              icon: Icons.location_on_outlined,
              text: 'Westlands, Nairobi',
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
      expect(find.text('Westlands, Nairobi'), findsOneWidget);
    });

    testWidgets('renders the trailing widget when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              icon: Icons.schedule,
              text: '2:00 PM',
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });
}