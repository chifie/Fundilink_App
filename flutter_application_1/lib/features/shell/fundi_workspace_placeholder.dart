import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';

/// Shown after a fundi signs in. The fundi workspace (incoming requests,
/// job management, earnings) is being built in a later release, so this
/// screen explains the state and offers a way back to the customer flow.
class FundiWorkspacePlaceholder extends StatelessWidget {
  const FundiWorkspacePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingXL),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySurface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.construction,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXL),
                Text(
                  'Fundi workspace',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                Text(
                  'Hi ${user?.fullName ?? ''}! The fundi dashboard is coming '
                  'soon. For now, log out and sign in with a customer account '
                  '(${AppStrings.appName} demo: brian@example.com) to explore '
                  'booking services.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceXXL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.read<AuthProvider>().logout(),
                    icon: const Icon(Icons.logout),
                    label: const Text(AppStrings.logout),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
