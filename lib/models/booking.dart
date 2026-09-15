import 'fundi.dart';

/// Coarse lifecycle of a booking, used for filtering and status chips.
enum BookingStatus { active, completed, cancelled }

/// Fine-grained progress within an active booking.
enum RequestStep { requested, accepted, inProgress, done }

/// A customer request for a fundi's service.
class Booking {
  const Booking({
    required this.id,
    required this.fundi,
    required this.service,
    required this.scheduledAt,
    required this.price,
    required this.status,
    required this.step,
  });

  final String id;
  final FundiProfile fundi;
  final String service;
  final DateTime scheduledAt;
  final int price;
  final BookingStatus status;
  final RequestStep step;

  /// Compact, timezone-free label such as "Sep 20 · 2:00 PM".
  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[scheduledAt.month - 1];
    final hour12 = scheduledAt.hour % 12 == 0 ? 12 : scheduledAt.hour % 12;
    final suffix = scheduledAt.hour < 12 ? 'AM' : 'PM';
    final minute = scheduledAt.minute.toString().padLeft(2, '0');
    return '$month ${scheduledAt.day} · $hour12:$minute $suffix';
  }
}
