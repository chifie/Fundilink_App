import '../models/booking.dart';
import '../models/chat.dart';
import '../models/fundi.dart';

/// In-memory catalogue powering the demo UI.
abstract final class MockData {
  static const List<FundiProfile> fundis = [
    FundiProfile(
      name: 'Grace Wanjiku',
      skill: FundiSkill.cleaning,
      rating: 4.9,
      reviewCount: 132,
      jobsDone: 214,
      pricePerHour: 600,
      isOnline: true,
    ),
    FundiProfile(
      name: 'Brian Otieno',
      skill: FundiSkill.electrical,
      rating: 4.8,
      reviewCount: 98,
      jobsDone: 156,
      pricePerHour: 800,
      isOnline: true,
    ),
    FundiProfile(
      name: 'Joseph Kamau',
      skill: FundiSkill.plumbing,
      rating: 4.7,
      reviewCount: 76,
      jobsDone: 121,
      pricePerHour: 700,
      isOnline: false,
    ),
    FundiProfile(
      name: 'Mary Achieng',
      skill: FundiSkill.moving,
      rating: 4.9,
      reviewCount: 64,
      jobsDone: 89,
      pricePerHour: 1500,
      isOnline: false,
    ),
    FundiProfile(
      name: 'Peter Mutua',
      skill: FundiSkill.painting,
      rating: 4.6,
      reviewCount: 51,
      jobsDone: 77,
      pricePerHour: 650,
      isOnline: true,
    ),
    FundiProfile(
      name: 'Faith Njeri',
      skill: FundiSkill.repairs,
      rating: 4.8,
      reviewCount: 110,
      jobsDone: 168,
      pricePerHour: 750,
      isOnline: false,
    ),
  ];

  static final List<Booking> bookings = [
    Booking(
      id: 'b1',
      fundi: fundis[0],
      service: 'Deep house cleaning',
      scheduledAt: DateTime(2026, 9, 20, 14),
      price: 1800,
      status: BookingStatus.active,
      step: RequestStep.inProgress,
    ),
    Booking(
      id: 'b2',
      fundi: fundis[1],
      service: 'Fix kitchen wiring',
      scheduledAt: DateTime(2026, 9, 22, 9, 30),
      price: 2500,
      status: BookingStatus.active,
      step: RequestStep.accepted,
    ),
    Booking(
      id: 'b3',
      fundi: fundis[2],
      service: 'Leaking sink repair',
      scheduledAt: DateTime(2026, 9, 5, 11),
      price: 1200,
      status: BookingStatus.completed,
      step: RequestStep.done,
    ),
    Booking(
      id: 'b4',
      fundi: fundis[3],
      service: 'Move furniture to Kilimani',
      scheduledAt: DateTime(2026, 9, 2, 8),
      price: 6000,
      status: BookingStatus.cancelled,
      step: RequestStep.requested,
    ),
  ];

  /// Bookings currently in flight, newest first.
  static List<Booking> get activeBookings =>
      bookings.where((b) => b.status == BookingStatus.active).toList();

  static const List<Conversation> chats = [
    Conversation(
      name: 'Grace Wanjiku',
      lastMessage: 'I will be there in 20 minutes 🙂',
      timeLabel: '09:41',
      unreadCount: 2,
      isOnline: true,
    ),
    Conversation(
      name: 'Brian Otieno',
      lastMessage: 'Sawa, the quote is KSh 2,500.',
      timeLabel: 'Mon',
      unreadCount: 0,
      isOnline: true,
    ),
    Conversation(
      name: 'Joseph Kamau',
      lastMessage: 'Thanks for the job, karibu tena!',
      timeLabel: 'Tue',
      unreadCount: 0,
      isOnline: false,
    ),
    Conversation(
      name: 'Faith Njeri',
      lastMessage: 'Can we reschedule to Friday?',
      timeLabel: 'Wed',
      unreadCount: 1,
      isOnline: false,
    ),
  ];
}
