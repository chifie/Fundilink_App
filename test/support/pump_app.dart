import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/store_scope.dart';

/// Pumps [home] with a store in scope, mirroring how `main.dart` builds the
/// app: the scope wraps `MaterialApp` so pushed routes and modal sheets can
/// reach the store too.
///
/// Pass a pre-seeded [store] when the test needs to assert on mutations.
Future<void> pumpWithStore(
  WidgetTester tester,
  Widget home, {
  AppStore? store,
}) async {
  await tester.pumpWidget(
    StoreScope(
      store: store ?? AppStore(),
      child: MaterialApp(home: home),
    ),
  );
  await tester.pumpAndSettle();
}
