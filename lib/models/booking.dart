import '../utils/formatters.dart';
import 'fundi.dart';

/// Lifecycle of a booking from request to review.
///
/// `active` is kept only so older saved demo data can still be opened. New
/// bookings use the explicit MVP statuses from the FundiLink workflow.
enum BookingStatus {
  pending,
  accepted,
  rejected,
  cancelled,
  onTheWay,
  inProgress,
  completed,
  paymentPending,
  paid,
  rated,
  active,
}

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
    this.location = 'Customer location',
    this.notes = '',
    this.workCompleted,
    this.labourCost = 0,
    this.materialCost = 0,
    int? totalAmount,
    this.paymentMethod,
    this.rating,
    this.review,
  });

  final String id;
  final FundiProfile fundi;
  final String service;
  final DateTime scheduledAt;
  final int price;
  final BookingStatus status;
  final RequestStep step;
  final String location;
  final String notes;
  final String? workCompleted;
  final int labourCost;
  final int materialCost;
  final int? totalAmount;
  final String? paymentMethod;
  final int? rating;
  final String? review;

  /// Compact, timezone-free label such as "Sep 20 · 2:00 PM".
  String get dateLabel => Formatters.dateTime(scheduledAt);

  /// Amount the customer sees after a job is priced.
  int get payableAmount => totalAmount ?? price;

  /// True while the job is still open or awaiting payment/review.
  bool get isActive => switch (status) {
    BookingStatus.pending ||
    BookingStatus.accepted ||
    BookingStatus.onTheWay ||
    BookingStatus.inProgress ||
    BookingStatus.paymentPending ||
    BookingStatus.paid ||
    BookingStatus.active => true,
    BookingStatus.rejected ||
    BookingStatus.cancelled ||
    BookingStatus.completed ||
    BookingStatus.rated => false,
  };

  /// True when the fundi can still act on the request.
  bool get isFundiActionable => switch (status) {
    BookingStatus.pending ||
    BookingStatus.accepted ||
    BookingStatus.onTheWay ||
    BookingStatus.inProgress ||
    BookingStatus.active => true,
    _ => false,
  };

  /// Copy with any field replaced; omitted fields keep their value.
  Booking copyWith({
    String? id,
    FundiProfile? fundi,
    String? service,
    DateTime? scheduledAt,
    int? price,
    BookingStatus? status,
    RequestStep? step,
    String? location,
    String? notes,
    String? workCompleted,
    int? labourCost,
    int? materialCost,
    int? totalAmount,
    String? paymentMethod,
    int? rating,
    String? review,
  }) => Booking(
    id: id ?? this.id,
    fundi: fundi ?? this.fundi,
    service: service ?? this.service,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    price: price ?? this.price,
    status: status ?? this.status,
    step: step ?? this.step,
    location: location ?? this.location,
    notes: notes ?? this.notes,
    workCompleted: workCompleted ?? this.workCompleted,
    labourCost: labourCost ?? this.labourCost,
    materialCost: materialCost ?? this.materialCost,
    totalAmount: totalAmount ?? this.totalAmount,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    rating: rating ?? this.rating,
    review: review ?? this.review,
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
          other.step == step &&
          other.location == location &&
          other.notes == notes &&
          other.workCompleted == workCompleted &&
          other.labourCost == labourCost &&
          other.materialCost == materialCost &&
          other.totalAmount == totalAmount &&
          other.paymentMethod == paymentMethod &&
          other.rating == rating &&
          other.review == review;

  @override
  int get hashCode => Object.hashAll([
    id,
    fundi,
    service,
    scheduledAt,
    price,
    status,
    step,
    location,
    notes,
    workCompleted,
    labourCost,
    materialCost,
    totalAmount,
    paymentMethod,
    rating,
    review,
  ]);

  /// Rebuilds a booking from the JSON written by [toJson].
  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    fundi: FundiProfile.fromJson(json['fundi'] as Map<String, dynamic>),
    service: json['service'] as String,
    scheduledAt: DateTime.parse(json['scheduledAt'] as String),
    price: json['price'] as int,
    status: _statusFromName(json['status'] as String),
    step: RequestStep.values.byName(json['step'] as String),
    location: json['location'] as String? ?? 'Customer location',
    notes: json['notes'] as String? ?? '',
    workCompleted: json['workCompleted'] as String?,
    labourCost: json['labourCost'] as int? ?? 0,
    materialCost: json['materialCost'] as int? ?? 0,
    totalAmount: json['totalAmount'] as int?,
    paymentMethod: json['paymentMethod'] as String?,
    rating: json['rating'] as int?,
    review: json['review'] as String?,
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
    'location': location,
    'notes': notes,
    'workCompleted': workCompleted,
    'labourCost': labourCost,
    'materialCost': materialCost,
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'rating': rating,
    'review': review,
  };

  static BookingStatus _statusFromName(String name) =>
      BookingStatus.values.asNameMap()[name] ?? BookingStatus.pending;
}
