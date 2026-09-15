import 'package:flutter/material.dart';

import '../models/booking.dart';
import '../screens/booking_detail_sheet.dart';
import '../screens/fundi_detail_sheet.dart';
import '../state/store_scope.dart';
import '../widgets/booking_card.dart';
import '../widgets/empty_state.dart';

/// Bookings tab with an Active / Completed / Cancelled filter.
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  BookingStatus _filter = BookingStatus.active;

  /// Cancelling is irreversible here, so it goes through a confirmation.
  Future<void> _confirmCancel(Booking booking) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel this booking?'),
        content: Text(
          '${booking.service} with ${booking.fundi.name} will be cancelled.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel booking'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    context.storeRead.cancelBooking(booking.id);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${booking.service} cancelled')));
  }

  @override
  Widget build(BuildContext context) {
    // Watching the store keeps this list in step with cancellations and
    // with requests created from the new-request sheet.
    final bookings = context.store.bookingsWithStatus(_filter);

    return Scaffold(
      appBar: AppBar(title: const Text('My bookings')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SegmentedButton<BookingStatus>(
              segments: const [
                ButtonSegment(
                  value: BookingStatus.active,
                  label: Text('Active'),
                  icon: Icon(Icons.schedule),
                ),
                ButtonSegment(
                  value: BookingStatus.completed,
                  label: Text('Done'),
                  icon: Icon(Icons.check_circle_outline),
                ),
                ButtonSegment(
                  value: BookingStatus.cancelled,
                  label: Text('Cancelled'),
                  icon: Icon(Icons.cancel_outlined),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) =>
                  setState(() => _filter = selection.first),
            ),
          ),
          Expanded(
            child: bookings.isEmpty
                ? const EmptyState(
                    icon: Icons.event_busy_outlined,
                    title: 'Nothing here yet',
                    message:
                        'Book a fundi and your requests will show up here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BookingCard(
                        booking: bookings[index],
                        onDetails: () =>
                            showBookingDetailSheet(context, bookings[index]),
                        onCancel: () => _confirmCancel(bookings[index]),
                        onRebook: () => showFundiDetailSheet(
                          context,
                          bookings[index].fundi,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
