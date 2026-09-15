import 'package:flutter/material.dart';

import '../screens/appearance_screen.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/saved_addresses_screen.dart';
import '../state/store_scope.dart';
import '../widgets/fundi_avatar.dart';
import '../widgets/settings_tile.dart';

/// Profile tab: identity header plus grouped settings tiles.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final profile = context.store.profile;

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
              FundiAvatar(name: profile.name, size: 72),
              const SizedBox(height: 12),
              Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile.location,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SettingsGroup(
            title: 'Account',
            tiles: [
              SettingsTile(
                icon: Icons.person_outline,
                label: 'Edit profile',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const EditProfileScreen(),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.location_on_outlined,
                label: 'Saved addresses',
                trailing: Text('${context.store.addresses.length}'),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SavedAddressesScreen(),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.payments_outlined,
                label: 'Payment methods',
                onTap: () {},
              ),
            ],
          ),
          SettingsGroup(
            title: 'Preferences',
            tiles: [
              SettingsTile(
                icon: Icons.dark_mode_outlined,
                label: 'Appearance',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AppearanceScreen(),
                  ),
                ),
              ),
              SettingsTile(
                icon: Icons.notifications_outlined,
                label: 'Notifications',
                onTap: () {},
              ),
            ],
          ),
          SettingsGroup(
            title: 'Support',
            tiles: [
              SettingsTile(
                icon: Icons.help_outline,
                label: 'Help center',
                onTap: () {},
              ),
              SettingsTile(
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
