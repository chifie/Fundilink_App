import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_info.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../widgets/dialogs/confirm_dialog.dart';
import '../../../widgets/feedback/toast.dart';

/// App settings and account management screen.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        children: [
          // Account section
          const _SectionLabel(label: AppStrings.accountSection),
          const SizedBox(height: AppDimensions.spaceS),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.person_outline,
                  title: AppStrings.editProfile,
                  onTap: () => Toast.showComingSoon(
                    context,
                    message: AppStrings.profileEditingComingSoon,
                  ),
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.lock_outline,
                  title: AppStrings.changePassword,
                  onTap: () => Toast.showComingSoon(
                    context,
                    message: AppStrings.passwordChangeComingSoon,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // App section
          const _SectionLabel(label: AppStrings.appSection),
          const SizedBox(height: AppDimensions.spaceS),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: AppStrings.language,
                  subtitle: AppStrings.english,
                  onTap: () => Toast.showComingSoon(
                    context,
                    message: AppStrings.languageSelectionComingSoon,
                  ),
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: AppStrings.darkMode,
                  trailing: Switch(
                    value: settings.isDarkMode,
                    onChanged: (value) =>
                        context.read<SettingsProvider>().setDarkMode(value),
                    activeThumbColor: AppColors.forestGreen,
                  ),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: AppStrings.pushNotifications,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) => Toast.show(
                      context,
                      value
                          ? AppStrings.notificationsEnabled
                          : AppStrings.notificationsDisabled,
                    ),
                    activeThumbColor: AppColors.forestGreen,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Support section
          const _SectionLabel(label: AppStrings.supportSection),
          const SizedBox(height: AppDimensions.spaceS),
          Card(
            margin: EdgeInsets.zero,
            child: Column(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: AppStrings.help,
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text(AppStrings.help),
                      content: Text(
                        'Reach our support team at ${AppInfo.supportEmail} '
                        'or visit the help centre in the app menu.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text(AppStrings.ok),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: AppStrings.aboutApp,
                  onTap: () => showAboutDialog(
                    context: context,
                    applicationName: AppInfo.appName,
                    applicationVersion: AppInfo.version,
                    applicationLegalese: AppInfo.tagline,
                    children: const [
                      Text(
                        'Connect with trusted local fundis for all your '
                        'service needs.',
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.description_outlined,
                  title: AppStrings.privacyPolicy,
                  onTap: () => Toast.showComingSoon(
                    context,
                    message: AppStrings.privacyPolicyComingSoon,
                  ),
                ),
                const Divider(height: 1, indent: 52),
                _SettingsTile(
                  icon: Icons.gavel_outlined,
                  title: AppStrings.termsOfService,
                  onTap: () => Toast.showComingSoon(
                    context,
                    message: AppStrings.termsComingSoon,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXL),

          // Logout
          SizedBox(
            height: AppDimensions.buttonHeight,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text(AppStrings.logout),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceM),
          Text(
            'Signed in as ${user?.email ?? ''}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textHint, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final auth = context.read<AuthProvider>();
    final confirmed = await showConfirmDialog(
      context,
      title: AppStrings.logout,
      message: AppStrings.logoutConfirm,
      confirmLabel: AppStrings.logout,
      confirmColor: AppColors.error,
    );
    if (!confirmed) return;
    await auth.logout();
    navigator.popUntil((route) => route.isFirst);
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingM,
      ),
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            )
          : null,
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
      onTap: onTap,
    );
  }
}
