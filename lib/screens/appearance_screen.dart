import 'package:flutter/material.dart';

import '../state/store_scope.dart';

/// One selectable scheme: its mode, label, explanation and icon.
typedef AppearanceOption = ({
  ThemeMode mode,
  String label,
  String detail,
  IconData icon,
});

/// Lets the customer pick between the system, light and dark schemes.
class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  static const List<AppearanceOption> options = [
    (
      mode: ThemeMode.system,
      label: 'System default',
      detail: 'Follow your device setting',
      icon: Icons.brightness_auto_outlined,
    ),
    (
      mode: ThemeMode.light,
      label: 'Light',
      detail: 'Always use the light scheme',
      icon: Icons.light_mode_outlined,
    ),
    (
      mode: ThemeMode.dark,
      label: 'Dark',
      detail: 'Always use the dark scheme',
      icon: Icons.dark_mode_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selected = context.store.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: options.length,
        separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.mode == selected;

          return ListTile(
            leading: Icon(
              option.icon,
              color: isSelected ? colors.primary : colors.onSurfaceVariant,
            ),
            title: Text(option.label),
            subtitle: Text(option.detail),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: colors.primary)
                : null,
            selected: isSelected,
            onTap: () => context.storeRead.setThemeMode(option.mode),
          );
        },
      ),
    );
  }
}
