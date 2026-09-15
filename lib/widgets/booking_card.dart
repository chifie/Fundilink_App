import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../utils/formatters.dart';
import 'fundi_avatar.dart';
import 'status_badge.dart';

/// Booking summary card with status badge and progress tracker.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onDetails,
    this.onCancel,
    this.onRebook,
  });

  final Booking booking;
  final VoidCallback? onDetails;
  final VoidCallback? onCancel;
  final VoidCallback? onRebook;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isActive = booking.status == BookingStatus.active;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FundiAvatar(name: booking.fundi.name),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.fundi.name, style: text.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        booking.service,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 16,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(booking.dateLabel, style: text.labelMedium),
                const Spacer(),
                Text(
                  Formatters.currency(booking.price),
                  style: text.titleSmall?.copyWith(color: colors.primary),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              _ProgressTracker(step: booking.step),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetails,
                    child: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: isActive
                      ? FilledButton.tonal(
                          onPressed: onCancel,
                          child: const Text('Cancel'),
                        )
                      : FilledButton(
                          onPressed: onRebook,
                          child: const Text('Rebook'),
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

/// Horizontal stepper visualising the request lifecycle.
class _ProgressTracker extends StatelessWidget {
  const _ProgressTracker({required this.step});

  final RequestStep step;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final labels = ['Requested', 'Accepted', 'In progress', 'Done'];
    final index = step.index;

    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i <= index
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: i <= index
                        ? colors.onSurface
                        : colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (i < labels.length - 1)
            Container(
              width: 16,
              height: 2,
              margin: const EdgeInsets.only(bottom: 18),
              color: i < index
                  ? colors.primary
                  : colors.surfaceContainerHighest,
            ),
        ],
      ],
    );
  }
}
