import '../utils/formatters.dart';
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
  String get dateLabel => Formatters.dateTime(scheduledAt);

  /// True while the fundi is still expected to show up.
  bool get isActive => status == BookingStatus.active;

  /// Copy with any field replaced; omitted fields keep their value.
  Booking copyWith({
    String? id,
    FundiProfile? fundi,
    String? service,
    DateTime? scheduledAt,
    int? price,
    BookingStatus? status,
    RequestStep? step,
  }) => Booking(
    id: id ?? this.id,
    fundi: fundi ?? this.fundi,
    service: service ?? this.service,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    price: price ?? this.price,
    status: status ?? this.status,
    step: step ?? this.step,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Booking &&
          other.id == id &&
          other.fundi == fundi &&
          other.service == service &&
          other.scheduledAt == scheduledAt &&
          other.price == price &&
          other.status == status &&
          other.step == step;

  @override
  int get hashCode =>
      Object.hash(id, fundi, service, scheduledAt, price, status, step);

  /// Rebuilds a booking from the JSON written by [toJson].
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    fundi: FundiProfile.fromJson(json['fundi'] as Map<String, dynamic>),
    service: json['service'] as String,
    scheduledAt: DateTime.parse(json['scheduledAt'] as String),
    price: json['price'] as int,
    status: BookingStatus.values.byName(json['status'] as String),
    step: RequestStep.values.byName(json['step'] as String),
  );

  /// Plain JSON map, safe for `jsonEncode` and local persistence.
  Map<String, dynamic> toJson() => {
    'id': id,
    'fundi': fundi.toJson(),
    'service': service,
    'scheduledAt': scheduledAt.toIso8601String(),
    'price': price,
    'status': status.name,
    'step': step.name,
  };
}
