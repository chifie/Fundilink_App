import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

/// Shows an informational dialog with a single OK button.
void showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text(AppStrings.ok),
        ),
      ],
    ),
  );
}
