import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_store.dart';

/// Makes an [AppStore] available to every widget below it.
///
/// The store is passed by value, so whoever created it owns disposing it.
class StoreScope extends StatelessWidget {
  const StoreScope({super.key, required this.store, required this.child});

  final AppStore store;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<AppStore>.value(value: store, child: child);
}

/// Shorthands for reaching the store from a widget.
extension StoreContext on BuildContext {
  /// The store, with a rebuild whenever it changes: use inside `build`.
  AppStore get store => watch<AppStore>();

  /// The store without subscribing: use from callbacks and `initState`.
  AppStore get storeRead => read<AppStore>();
}
