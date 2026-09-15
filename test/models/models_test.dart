import 'dart:convert';

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

const Conversation _conversation = Conversation(
  name: 'Grace Wanjiku',
  lastMessage: 'I will be there in 20 minutes 🙂',
  timeLabel: '09:41',
  unreadCount: 2,
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

/// Round-trips a map through a real JSON string, so the test also catches
/// values that are not actually encodable.
Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

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
    test('hasUnread is false once the counter reaches zero', () {
      expect(_conversation.hasUnread, isTrue);
      expect(_conversation.copyWith(unreadCount: 0).hasUnread, isFalse);
    });

    test('copyWith updates the preview and keeps the rest', () {
      final updated = _conversation.copyWith(
        lastMessage: 'Karibu!',
        timeLabel: '10:02',
      );

      expect(updated.lastMessage, 'Karibu!');
      expect(updated.timeLabel, '10:02');
      expect(updated.name, _conversation.name);
      expect(updated.unreadCount, _conversation.unreadCount);
      expect(updated == _conversation, isFalse);
    });
  });

  group('JSON serialization', () {
    test('FundiProfile round-trips through a JSON string', () {
      final restored = FundiProfile.fromJson(_throughJson(_grace.toJson()));

      expect(restored, _grace);
      expect(restored.skill, FundiSkill.cleaning);
      expect(restored.rating, 4.9);
    });

    test('Booking round-trips its nested fundi and schedule', () {
      final booking = _booking(status: BookingStatus.completed);
      final restored = Booking.fromJson(_throughJson(booking.toJson()));

      expect(restored, booking);
      expect(restored.fundi, _grace);
      expect(restored.scheduledAt, DateTime(2026, 9, 20, 14));
      expect(restored.status, BookingStatus.completed);
    });

    test('Conversation round-trips through a JSON string', () {
      final restored = Conversation.fromJson(
        _throughJson(_conversation.toJson()),
      );

      expect(restored, _conversation);
    });

    test('enums are persisted by name, not by index', () {
      expect(_booking().toJson()['step'], 'inProgress');
      expect(_booking().toJson()['status'], 'active');
    });
  });
}
