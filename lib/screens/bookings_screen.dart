import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/booking.dart';
import '../screens/booking_detail_sheet.dart';
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

  @override
  Widget build(BuildContext context) {
    final bookings =
        MockData.bookings.where((b) => b.status == _filter).toList();

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
                    message: 'Book a fundi and your requests will show up here.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: BookingCard(
                        booking: bookings[index],
                        onDetails: () => showBookingDetailSheet(
                          context,
                          bookings[index],
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
