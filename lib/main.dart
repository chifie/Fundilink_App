import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shell/home_shell.dart';
import 'state/app_store.dart';
import 'state/key_value_store.dart';
import 'state/store_scope.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(MyApp(store: AppStore(storage: PrefsKeyValueStore(preferences))));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.store});

  /// Application state, owned by the app so it can be disposed on teardown.
  final AppStore store;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The scope sits above MaterialApp so modal sheets, which are pushed
    // onto the app's navigator, can still reach the store.
    return StoreScope(
      store: widget.store,
      child: Consumer<AppStore>(
        builder: (context, store, _) => MaterialApp(
          title: 'Fundilink',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: store.themeMode,
          home: const HomeShell(),
        ),
      ),
    );
  }
}
