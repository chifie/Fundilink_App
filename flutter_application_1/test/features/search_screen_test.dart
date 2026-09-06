import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/search/screens/search_screen.dart';
import 'package:fundi_link/providers/fundi_provider.dart';
import 'package:fundi_link/widgets/fundi_card.dart';
import 'package:provider/provider.dart';

Widget _wrap(FundiProvider fundi) {
  return ChangeNotifierProvider<FundiProvider>.value(
    value: fundi,
    child: const MaterialApp(home: SearchScreen()),
  );
}

void main() {
  testWidgets('typing searches after the debounce delay', (tester) async {
    final fundi = FundiProvider();
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi));
    await tester.pump(const Duration(milliseconds: 700));

    // All fundis are listed once the initial load completes.
    expect(find.byType(FundiCard), findsWidgets);

    await tester.enterText(find.byType(TextField), 'Wanjiku');
    await tester.pump();

    // Before the debounce fires the full list is still shown.
    expect(find.byType(FundiCard), findsWidgets);

    // Let the debounce (350ms) and the repository latency (500ms) elapse.
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Mary Wanjiku'), findsOneWidget);
    expect(find.byType(FundiCard), findsOneWidget);
  });

  testWidgets('shows the empty state when nothing matches', (tester) async {
    final fundi = FundiProvider();
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.enterText(find.byType(TextField), 'zzzzz');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text(AppStrings.noResults), findsOneWidget);
    expect(find.byType(FundiCard), findsNothing);
  });

  testWidgets('clearing the query restores the full list', (tester) async {
    final fundi = FundiProvider();
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.enterText(find.byType(TextField), 'Wanjiku');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(FundiCard), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(FundiCard), findsWidgets);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}