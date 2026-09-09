import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/widgets/count_up_stat_card.dart';
import 'package:fundi_link/widgets/layout/page_scaffold.dart';

void main() {
  group('CountUpStatCard', () {
    testWidgets('renders the final value, icon and label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountUpStatCard(
              label: 'Pending',
              value: 5,
              icon: Icons.schedule,
              color: Colors.orange,
            ),
          ),
        ),
      );
      // Let the count-up animation finish.
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets('fires onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountUpStatCard(
              label: 'Completed',
              value: 3,
              icon: Icons.verified_outlined,
              color: Colors.green,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Completed'));
      expect(tapped, isTrue);
    });

    testWidgets('uses a custom formatter', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountUpStatCard(
              label: 'Earned',
              value: 1200,
              icon: Icons.payments_outlined,
              color: Colors.green,
              formatter: (v) => 'KES ${v.round()}',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('KES 1200'), findsOneWidget);
    });
  });

  group('PageScaffold', () {
    testWidgets('renders a centered app bar title and the body', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageScaffold(title: 'Settings', body: Text('Body content')),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Body content'), findsOneWidget);
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });

    testWidgets('shows app bar actions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PageScaffold(
            title: 'Inbox',
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.done_all),
              ),
            ],
            body: const SizedBox(),
          ),
        ),
      );

      expect(find.byIcon(Icons.done_all), findsOneWidget);
    });

    testWidgets('wraps the body in a RefreshIndicator when refresh is given',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: PageScaffold(
            title: 'Notifications',
            refresh: () async {},
            body: ListView(children: const [Text('Item')]),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('omits the RefreshIndicator when refresh is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: PageScaffold(title: 'Static', body: SizedBox()),
        ),
      );

      expect(find.byType(RefreshIndicator), findsNothing);
    });
  });
}
