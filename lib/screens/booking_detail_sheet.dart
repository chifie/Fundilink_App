import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../utils/formatters.dart';
import '../widgets/fundi_avatar.dart';
import '../widgets/status_badge.dart';

/// Modal sheet with full booking details and a progress timeline.
void showBookingDetailSheet(BuildContext context, Booking booking) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _BookingDetailSheet(booking: booking),
  );
}

class _BookingDetailSheet extends StatelessWidget {
  const _BookingDetailSheet({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final labels = ['Requested', 'Accepted', 'In progress', 'Done'];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                FundiAvatar(name: booking.fundi.name, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.fundi.name, style: text.titleLarge),
                      const SizedBox(height: 2),
                      Text(
                        booking.service,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                StatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(booking.dateLabel, style: text.bodyMedium),
                const Spacer(),
                Text(
                  Formatters.currency(booking.price),
                  style: text.titleMedium?.copyWith(color: colors.primary),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(booking.location, style: text.bodyMedium)),
              ],
            ),
            if (booking.notes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                booking.notes,
                style: text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
            if (booking.workCompleted != null) ...[
              const SizedBox(height: 12),
              Text('Work completed', style: text.titleSmall),
              const SizedBox(height: 4),
              Text(booking.workCompleted!),
              const SizedBox(height: 4),
              Text(
                'Total: ${Formatters.currency(booking.payableAmount)}',
                style: text.titleSmall?.copyWith(color: colors.primary),
              ),
            ],
            const SizedBox(height: 20),
            for (var i = 0; i < labels.length; i++)
              _TimelineTile(
                label: labels[i],
                isDone: i <= booking.step.index,
                isLast: i == labels.length - 1,
              ),
            const SizedBox(height: 20),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical timeline row for one request step.
class _TimelineTile extends StatelessWidget {
  const _TimelineTile({
    required this.label,
    required this.isDone,
    required this.isLast,
  });

  final String label;
  final bool isDone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone
                        ? colors.primary
                        : colors.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(
                color: isDone ? colors.onSurface : colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
