import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/dialogs/confirm_dialog.dart';

/// Confirms with the user, signs out and returns to the first route.
///
/// Shared by the profile and settings screens so logout behaves identically
/// everywhere.
Future<void> signOut(BuildContext context) async {
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
