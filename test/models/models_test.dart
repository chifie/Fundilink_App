import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/chat.dart';
import 'package:fundilink_app/models/fundi.dart';

const FundiProfile _grace = FundiProfile(
  name: 'Grace Wanjiku',
  skill: FundiSkill.cleaning,
  rating: 4.9,
  reviewCount: 132,
  jobsDone: 214,
  pricePerHour: 600,
  isOnline: true,
);

Booking _booking({
  BookingStatus status = BookingStatus.active,
  RequestStep step = RequestStep.inProgress,
}) => Booking(
  id: 'b1',
  fundi: _grace,
  service: 'Deep house cleaning',
  scheduledAt: DateTime(2026, 9, 20, 14),
  price: 1800,
  status: status,
  step: step,
);

void main() {
  group('FundiProfile', () {
    test('equality compares every field', () {
      expect(_grace, _grace.copyWith());
      expect(_grace == _grace.copyWith(name: 'Someone else'), isFalse);
      expect(_grace == _grace.copyWith(isOnline: false), isFalse);
      expect(_grace.hashCode, _grace.copyWith().hashCode);
    });

    test('copyWith only replaces the fields it is given', () {
      final updated = _grace.copyWith(pricePerHour: 750, jobsDone: 300);

      expect(updated.pricePerHour, 750);
      expect(updated.jobsDone, 300);
      expect(updated.name, _grace.name);
      expect(updated.skill, _grace.skill);
      expect(updated.rating, _grace.rating);
      expect(updated.isOnline, _grace.isOnline);
    });
  });

  group('Booking', () {
    test('dateLabel combines day and 12-hour time', () {
      expect(_booking().dateLabel, 'Sep 20 · 2:00 PM');
    });

    test('isActive tracks the coarse status', () {
      expect(_booking().isActive, isTrue);
      expect(_booking(status: BookingStatus.completed).isActive, isFalse);
      expect(_booking(status: BookingStatus.cancelled).isActive, isFalse);
    });

    test('copyWith can cancel a booking without touching its step', () {
      final cancelled = _booking().copyWith(status: BookingStatus.cancelled);

      expect(cancelled.status, BookingStatus.cancelled);
      expect(cancelled.step, RequestStep.inProgress);
      expect(cancelled.id, 'b1');
      expect(cancelled == _booking(), isFalse);
    });

    test('equality compares every field', () {
      expect(_booking(), _booking());
      expect(_booking() == _booking(step: RequestStep.done), isFalse);
    });
  });

  group('Conversation', () {
    const conversation = Conversation(
      name: 'Grace Wanjiku',
      lastMessage: 'I will be there in 20 minutes 🙂',
      timeLabel: '09:41',
      unreadCount: 2,
      isOnline: true,
    );

    test('hasUnread is false once the counter reaches zero', () {
      expect(conversation.hasUnread, isTrue);
      expect(conversation.copyWith(unreadCount: 0).hasUnread, isFalse);
    });

    test('copyWith updates the preview and keeps the rest', () {
      final updated = conversation.copyWith(
        lastMessage: 'Karibu!',
        timeLabel: '10:02',
      );

      expect(updated.lastMessage, 'Karibu!');
      expect(updated.timeLabel, '10:02');
      expect(updated.name, conversation.name);
      expect(updated.unreadCount, conversation.unreadCount);
      expect(updated == conversation, isFalse);
    });
  });
}
