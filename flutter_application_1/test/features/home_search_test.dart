import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundi_link/core/constants/app_strings.dart';
import 'package:fundi_link/features/home/screens/home_screen.dart';
import 'package:fundi_link/providers/auth_provider.dart';
import 'package:fundi_link/providers/fundi_provider.dart';
import 'package:fundi_link/providers/notification_provider.dart';
import 'package:fundi_link/providers/review_provider.dart';
import 'package:provider/provider.dart';

Widget _wrap(FundiProvider fundi, AuthProvider auth) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: fundi),
      ChangeNotifierProvider.value(value: auth),
      ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
    ],
    child: const MaterialApp(home: HomeScreen()),
  );
}

Future<void> _useTallViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('home renders categories and fundi rows after load', (tester) async {
    await _useTallViewport(tester);
    final fundi = FundiProvider();
    unawaited(fundi.loadCategories());
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi, AuthProvider()));
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text(AppStrings.popularCategories), findsOneWidget);
    expect(find.text(AppStrings.recommendedFundi), findsOneWidget);
    expect(find.text(AppStrings.nearbyFundi), findsOneWidget);
    expect(find.text('James Otieno'), findsWidgets);
    expect(find.text('Plumbing'), findsWidgets);
  });

  testWidgets('tapping a recommended fundi opens the profile', (tester) async {
    await _useTallViewport(tester);
    final fundi = FundiProvider();
    unawaited(fundi.loadCategories());
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi, AuthProvider()));
    await tester.pump(const Duration(milliseconds: 700));

    final james = find.text('James Otieno').first;
    await tester.ensureVisible(james);
    await tester.pump();
    await tester.tap(james);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text(AppStrings.fundiProfile), findsOneWidget);
    expect(find.text(AppStrings.about), findsOneWidget);
    expect(find.text(AppStrings.requestService), findsOneWidget);
    expect(find.textContaining('Certified plumber'), findsOneWidget);
  });

  testWidgets('home category chip asks the search tab to filter', (tester) async {
    await _useTallViewport(tester);
    final fundi = FundiProvider();
    unawaited(fundi.loadCategories());
    unawaited(fundi.loadFundis());
    await tester.pumpWidget(_wrap(fundi, AuthProvider()));
    await tester.pump(const Duration(milliseconds: 700));

    await tester.tap(find.text('Cleaning').first);
    await tester.pump();
  });
}
