import 'package:flutter/material.dart';

import '../state/store_scope.dart';
import '../widgets/fundi_avatar.dart';

/// Profile tab: identity header plus grouped settings tiles.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Toggle light/dark theme',
            // Reads the OS brightness so a store still following the system
            // scheme flips to the opposite of what is on screen.
            onPressed: () => context.storeRead.toggleTheme(
              platformBrightness: MediaQuery.platformBrightnessOf(context),
            ),
            icon: const Icon(Icons.brightness_6_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 8),
          Column(
            children: [
              const FundiAvatar(name: 'Amina Yusuf', size: 72),
              const SizedBox(height: 12),
              Text(
                'Amina Yusuf',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'amina.yusuf@example.com',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsGroup(
            title: 'Account',
            tiles: [
              _SettingsTile(
                icon: Icons.person_outline,
                label: 'Edit profile',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                label: 'Saved addresses',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.payments_outlined,
                label: 'Payment methods',
                onTap: () {},
              ),
            ],
          ),
          _SettingsGroup(
            title: 'Preferences',
            tiles: [
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                label: 'Appearance',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () {},
              ),
            ],
          ),
          _SettingsGroup(
            title: 'Support',
            tiles: [
              _SettingsTile(
                icon: Icons.help_outline,
                label: 'Help center',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.logout,
                label: 'Sign out',
                destructive: true,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card wrapping a titled group of settings tiles.
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.tiles});

  final String title;
  final List<_SettingsTile> tiles;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: text.labelMedium?.copyWith(
                color: text.labelMedium?.color?.withAlpha(153),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                for (var i = 0; i < tiles.length; i++) ...[
                  tiles[i],
                  if (i < tiles.length - 1)
                    const Divider(height: 1, indent: 56),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Single tappable settings row.
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = destructive ? colors.error : colors.onSurface;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      trailing: Icon(Icons.chevron_right, color: colors.onSurfaceVariant),
      onTap: onTap,
    );
  }
}
