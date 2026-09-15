import 'package:flutter/material.dart';

/// Friendly placeholder for empty lists and tabs.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.onAction,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(
              message,
              style: text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
