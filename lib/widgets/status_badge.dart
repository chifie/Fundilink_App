import 'package:flutter/material.dart';

import '../models/booking.dart';

/// Small rounded pill for filter chips.
class FilterChipPill extends StatelessWidget {
  const FilterChipPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

/// Colored status badge for booking states.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final (Color bg, Color fg, String label, IconData icon) = switch (status) {
      BookingStatus.pending => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        'Pending',
        Icons.hourglass_top_outlined,
      ),
      BookingStatus.accepted => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'Accepted',
        Icons.event_available_outlined,
      ),
      BookingStatus.rejected => (
        colors.errorContainer,
        colors.onErrorContainer,
        'Rejected',
        Icons.block_outlined,
      ),
      BookingStatus.onTheWay => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'On the way',
        Icons.directions_bike_outlined,
      ),
      BookingStatus.inProgress => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'In progress',
        Icons.construction_outlined,
      ),
      BookingStatus.active => (
        colors.primaryContainer,
        colors.onPrimaryContainer,
        'Active',
        Icons.schedule,
      ),
      BookingStatus.completed => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        'Completed',
        Icons.check_circle_outline,
      ),
      BookingStatus.paymentPending => (
        colors.tertiaryContainer,
        colors.onTertiaryContainer,
        'Payment',
        Icons.payments_outlined,
      ),
      BookingStatus.paid => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        'Paid',
        Icons.paid_outlined,
      ),
      BookingStatus.rated => (
        colors.secondaryContainer,
        colors.onSecondaryContainer,
        'Rated',
        Icons.star_outline,
      ),
      BookingStatus.cancelled => (
        colors.errorContainer,
        colors.onErrorContainer,
        'Cancelled',
        Icons.cancel_outlined,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
