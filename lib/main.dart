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
    final ColorScheme colors = Theme.of(context).colorScheme;
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
          const _SectionHeader('Buttons'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton(
                      onPressed: () {},
                      child: const Text('Filled'),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('Tonal'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Elevated'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Outlined'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Text'),
                    ),
                    const OutlinedButton(
                      onPressed: null,
                      child: Text('Disabled'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
              ],
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
          const _SectionHeader('Cards'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _CardBody(
                icon: Icons.style_outlined,
                title: 'Elevated card',
                subtitle: 'The default card: tonal surface, subtle shadow.',
              ),
            ),
          ),
          Card.filled(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _CardBody(
                icon: Icons.layers_outlined,
                title: 'Filled card',
                subtitle: 'Highest-emphasis tonal surface, no shadow.',
              ),
            ),
          ),
          Card.outlined(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _CardBody(
                icon: Icons.square_outlined,
                title: 'Outlined card',
                subtitle: 'Flat surface separated by a 1dp outline.',
              ),
            ),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.auto_awesome_outlined,
                          size: 20,
                          color: colors.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('Card with actions', style: text.titleMedium),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Cards can host any content plus an action row.',
                    style: text.bodyMedium,
                  ),
                ),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Learn more'),
                    ),
                    FilledButton.tonal(
                      onPressed: () {},
                      child: const Text('Get started'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: colors.onSecondaryContainer),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: text.titleMedium),
              const SizedBox(height: 2),
              Text(subtitle, style: text.bodyMedium),
            ],
          ),
        ),
      ],
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
