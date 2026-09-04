import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../fundi_avatar.dart';

/// Navigation drawer for the fundi shell.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // User header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FundiAvatar(
                    name: user?.fullName ?? '?',
                    radius: 28,
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    user?.fullName ?? '',
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      color: AppColors.textOnPrimary.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spaceM),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: AppColors.primary),
              title: const Text(AppStrings.home),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.primary),
              title: const Text(AppStrings.settings),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(AppStrings.logout, style: TextStyle(color: AppColors.error)),
              onTap: () async {
                Navigator.of(context).pop();
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text(AppStrings.logout),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text(AppStrings.logout),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  await context.read<AuthProvider>().logout();
                }
              },
            ),
            const SizedBox(height: AppDimensions.spaceM),
          ],
        ),
      ),
    );
  }
}
