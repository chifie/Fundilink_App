import 'package:flutter/material.dart';

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
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fundilink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: HomePage(onToggleTheme: _toggleTheme),
    );
  }
}

/// Showcase of the Material 3 design system.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fundilink'),
        actions: [
          IconButton(
            tooltip: 'Toggle light/dark theme',
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          const _SectionHeader('Counter'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$_counter', style: text.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Tap the FAB or the Increment button below.',
                    style: text.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const _SectionHeader('Typography'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Display Small', style: text.displaySmall),
                Text('Headline Medium', style: text.headlineMedium),
                Text('Title Large', style: text.titleLarge),
                const SizedBox(height: 4),
                Text(
                  'Body Large — Material 3 generates a full color scheme from '
                  'a single seed color and pairs it with a 15-style type scale.',
                  style: text.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text('Label Large', style: text.labelLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: text.labelLarge?.copyWith(color: colors.primary),
      ),
    );
  }
}
