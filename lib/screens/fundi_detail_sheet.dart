import 'package:flutter/material.dart';

import '../models/fundi.dart';
import '../widgets/fundi_avatar.dart';

/// Modal bottom sheet presenting a fundi before booking.
void showFundiDetailSheet(BuildContext context, FundiProfile fundi) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FundiDetailSheet(fundi: fundi),
  );
}

class _FundiDetailSheet extends StatelessWidget {
  const _FundiDetailSheet({required this.fundi});

  final FundiProfile fundi;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FundiAvatar(
                  name: fundi.name,
                  size: 64,
                  isOnline: fundi.isOnline,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fundi.name, style: text.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        fundi.skill.label,
                        style: text.bodyLarge?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.star_rounded,
                    value: '${fundi.rating}',
                    label: '${fundi.reviewCount} reviews',
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.work_outline,
                    value: '${fundi.jobsDone}',
                    label: 'jobs done',
                  ),
                ),
                Expanded(
                  child: _StatTile(
                    icon: Icons.payments_outlined,
                    value: '${fundi.pricePerHour}',
                    label: 'KSh / hour',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${fundi.name} is a verified ${fundi.skill.label.toLowerCase()} '
              'professional on FundiLink. Expect a reply within minutes '
              'during working hours.',
              style: text.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request sent to ${fundi.name}')),
                );
              },
              icon: const Icon(Icons.event_available_outlined),
              label: const Text('Book now'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon, value and caption used in the stats row.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(height: 4),
        Text(value, style: text.titleMedium),
        Text(
          label,
          style: text.labelSmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
