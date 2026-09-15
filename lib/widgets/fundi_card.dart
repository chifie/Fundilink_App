import 'package:flutter/material.dart';

import '../models/fundi.dart';
import 'fundi_avatar.dart';

/// List card presenting a fundi: avatar, rating, hourly price and actions.
class FundiCard extends StatelessWidget {
  const FundiCard({super.key, required this.fundi, this.onView, this.onBook});

  final FundiProfile fundi;
  final VoidCallback? onView;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                FundiAvatar(name: fundi.name, isOnline: fundi.isOnline),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fundi.name, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        fundi.skill.label,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: colors.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${fundi.rating} (${fundi.reviewCount})',
                            style: text.labelMedium,
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.work_outline,
                            size: 16,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${fundi.jobsDone} jobs',
                            style: text.labelMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'KSh ${fundi.pricePerHour}',
                      style: text.titleMedium?.copyWith(color: colors.primary),
                    ),
                    Text(
                      'per hour',
                      style: text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onView,
                    child: const Text('View'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onBook,
                    child: const Text('Book'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
