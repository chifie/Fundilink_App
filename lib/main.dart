import 'package:flutter/material.dart';

import 'shell/home_shell.dart';
import 'state/app_store.dart';
import 'state/store_scope.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Created here so the whole tree, including pushed routes and sheets,
  /// shares one store and the app owns disposing it.
  final AppStore _store = AppStore();

  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The scope sits above MaterialApp so modal sheets, which are pushed
    // onto the app's navigator, can still reach the store.
    return StoreScope(
      store: _store,
      child: MaterialApp(
        title: 'Fundilink',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _themeMode,
        home: HomeShell(onToggleTheme: _toggleTheme),
      ),
    );
  }
}
