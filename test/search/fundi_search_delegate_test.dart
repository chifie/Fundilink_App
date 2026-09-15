import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/search/fundi_search_delegate.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';
import 'package:fundilink_app/state/store_scope.dart';

import '../support/pump_app.dart';

/// Opens the search screen the way the home tab does.
class _SearchHost extends StatelessWidget {
  const _SearchHost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => showSearch<FundiProfile?>(
            context: context,
            delegate: FundiSearchDelegate(store: context.storeRead),
          ),
          child: const Text('Open search'),
        ),
      ),
    );
  }
}

void main() {
  Future<AppStore> openSearch(WidgetTester tester, {AppStore? store}) async {
    final target = store ?? AppStore(storage: InMemoryKeyValueStore());
    await pumpWithStore(tester, const _SearchHost(), store: target);
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    return target;
  }

  Future<void> type(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField), query);
    await tester.pumpAndSettle();
  }

  testWidgets('suggests the top-rated fundis before anything is typed', (
    tester,
  ) async {
    await openSearch(tester);

    expect(find.text('Suggested for you'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsOneWidget);
    expect(find.text('Recent searches'), findsNothing);
  });

  testWidgets('matches a fundi by name', (tester) async {
    await openSearch(tester);

    await type(tester, 'joseph');

    expect(find.text('Joseph Kamau'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsNothing);
  });

  testWidgets('matches a fundi by service, ignoring case', (tester) async {
    await openSearch(tester);

    await type(tester, 'PLUMB');

    expect(find.text('Joseph Kamau'), findsOneWidget);
    expect(find.text('Grace Wanjiku'), findsNothing);
  });

  testWidgets('explains when nothing matches', (tester) async {
    await openSearch(tester);

    await type(tester, 'astronaut');

    expect(find.text('No fundis found'), findsOneWidget);
    expect(
      find.text('Nothing matches "astronaut". Try another service or name.'),
      findsOneWidget,
    );
  });

  testWidgets('lists recent searches and reruns one when tapped', (
    tester,
  ) async {
    final store = AppStore(storage: InMemoryKeyValueStore())
      ..recordSearch('plumbing');
    await openSearch(tester, store: store);

    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('plumbing'), findsOneWidget);

    await tester.tap(find.text('plumbing'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      'plumbing',
    );
    expect(find.text('Joseph Kamau'), findsOneWidget);
  });

  testWidgets('clearing the history removes the chips', (tester) async {
    final store = AppStore(storage: InMemoryKeyValueStore())
      ..recordSearch('plumbing');
    await openSearch(tester, store: store);

    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(store.recentSearches, isEmpty);
    expect(find.text('Recent searches'), findsNothing);
  });

  testWidgets('selecting a fundi returns it to the caller', (tester) async {
    FundiProfile? selected;

    await pumpWithStore(
      tester,
      Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () async {
                selected = await showSearch<FundiProfile?>(
                  context: context,
                  delegate: FundiSearchDelegate(store: context.storeRead),
                );
              },
              child: const Text('Open search'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await type(tester, 'joseph');

    await tester.tap(find.text('Book'));
    await tester.pumpAndSettle();

    expect(selected?.name, 'Joseph Kamau');
  });
}
