import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/data/mock_data.dart';
import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/chat.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/state/app_store.dart';

const FundiProfile _grace = FundiProfile(
  name: 'Grace Wanjiku',
  skill: FundiSkill.cleaning,
  rating: 4.9,
  reviewCount: 132,
  jobsDone: 214,
  pricePerHour: 600,
  isOnline: true,
);

const FundiProfile _joseph = FundiProfile(
  name: 'Joseph Kamau',
  skill: FundiSkill.plumbing,
  rating: 4.7,
  reviewCount: 76,
  jobsDone: 121,
  pricePerHour: 700,
  isOnline: false,
);

Booking _booking({
  String id = 'b1',
  BookingStatus status = BookingStatus.active,
}) => Booking(
  id: id,
  fundi: _grace,
  service: 'Deep house cleaning',
  scheduledAt: DateTime(2026, 9, 20, 14),
  price: 1800,
  status: status,
  step: RequestStep.inProgress,
);

/// Store with a small, fully controlled fixture instead of the demo data.
AppStore _store({List<Booking>? bookings, List<Conversation>? conversations}) =>
    AppStore(
      fundis: const [_joseph, _grace],
      bookings: bookings ?? [_booking()],
      conversations:
          conversations ??
          const [
            Conversation(
              name: 'Grace Wanjiku',
              lastMessage: 'I will be there in 20 minutes 🙂',
              timeLabel: '09:41',
              unreadCount: 2,
              isOnline: true,
            ),
            Conversation(
              name: 'Joseph Kamau',
              lastMessage: 'Thanks for the job, karibu tena!',
              timeLabel: 'Tue',
              unreadCount: 0,
              isOnline: false,
            ),
          ],
      clock: () => DateTime(2026, 9, 15, 9, 41),
    );

void main() {
  group('seeding', () {
    test('defaults to the mock catalogue', () {
      final store = AppStore();

      expect(store.fundis, MockData.fundis);
      expect(store.bookings, MockData.bookings);
      expect(store.conversations, MockData.chats);
    });

    test('copying constructor lists keeps the store isolated', () {
      final fundis = [_grace];
      final store = AppStore(fundis: fundis);

      fundis.add(_joseph);
      store.updateFundi(_grace.copyWith(isOnline: false));

      expect(store.fundis, hasLength(1));
      expect(fundis.first.isOnline, isTrue);
    });

    test('exposed lists cannot be mutated by callers', () {
      final store = _store();

      expect(() => store.fundis.add(_grace), throwsUnsupportedError);
      expect(() => store.bookings.clear(), throwsUnsupportedError);
    });
  });

  group('catalogue', () {
    test('topRatedFundis sorts by rating and caps the list at three', () {
      final store = AppStore();
      final top = store.topRatedFundis;

      expect(top, hasLength(3));
      expect(top.first.name, 'Grace Wanjiku');
      for (var i = 0; i < top.length - 1; i++) {
        expect(top[i].rating, greaterThanOrEqualTo(top[i + 1].rating));
      }
    });

    test('fundiByName finds known names and ignores unknown ones', () {
      final store = _store();

      expect(store.fundiByName('Grace Wanjiku'), _grace);
      expect(store.fundiByName('Nobody'), isNull);
    });

    test('updateFundi replaces the record and notifies', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.updateFundi(_grace.copyWith(isOnline: false));

      expect(store.fundiByName('Grace Wanjiku')!.isOnline, isFalse);
      expect(notifications, 1);
    });

    test('updateFundi ignores an unknown fundi', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.updateFundi(_grace.copyWith(name: 'Unknown'));

      expect(notifications, 0);
    });
  });

  group('bookings', () {
    test('addBooking puts the newest request first', () {
      final store = _store();

      store.addBooking(_booking(id: 'b2'));

      expect(store.bookings.map((b) => b.id), ['b2', 'b1']);
    });

    test('cancelBooking only cancels active jobs', () {
      final store = _store(
        bookings: [
          _booking(id: 'b1'),
          _booking(id: 'b3', status: BookingStatus.completed),
        ],
      );

      store.cancelBooking('b1');
      store.cancelBooking('b3');
      store.cancelBooking('missing');

      expect(store.bookingsWithStatus(BookingStatus.cancelled), hasLength(1));
      expect(
        store.bookingsWithStatus(BookingStatus.completed),
        hasLength(1),
        reason: 'a completed job keeps its status',
      );
    });

    test('bookingsWithStatus filters by lifecycle stage', () {
      final store = _store(
        bookings: [
          _booking(id: 'b1'),
          _booking(id: 'b3', status: BookingStatus.completed),
        ],
      );

      expect(store.bookingsWithStatus(BookingStatus.active), hasLength(1));
      expect(store.bookingsWithStatus(BookingStatus.cancelled), isEmpty);
      expect(store.activeBookingCount, 1);
    });

    test('advanceBooking moves the tracker without leaving active', () {
      final store = _store();

      store.advanceBooking('b1', RequestStep.done);

      expect(store.bookings.single.step, RequestStep.done);
      expect(store.bookings.single.isActive, isTrue);
    });
  });

  group('conversations', () {
    test('sendMessage updates the preview, time and unread badge', () {
      final store = _store();

      store.sendMessage(contactName: 'Grace Wanjiku', text: '  Karibu!  ');

      final chat = store.conversations.first;
      expect(chat.lastMessage, 'Karibu!');
      expect(chat.timeLabel, '9:41 AM');
      expect(chat.hasUnread, isFalse);
    });

    test('sendMessage ignores blank input and unknown contacts', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.sendMessage(contactName: 'Grace Wanjiku', text: '   ');
      store.sendMessage(contactName: 'Nobody', text: 'Hello');

      expect(notifications, 0);
      expect(store.conversations.first.lastMessage, contains('20 minutes'));
    });

    test('markConversationRead clears one badge only', () {
      final store = _store(
        conversations: const [
          Conversation(
            name: 'Grace Wanjiku',
            lastMessage: 'On my way',
            timeLabel: '09:41',
            unreadCount: 2,
            isOnline: true,
          ),
          Conversation(
            name: 'Joseph Kamau',
            lastMessage: 'Karibu tena',
            timeLabel: 'Tue',
            unreadCount: 3,
            isOnline: false,
          ),
        ],
      );

      store.markConversationRead('Grace Wanjiku');

      expect(store.unreadMessageCount, 3);
    });

    test('unreadMessageCount sums every thread', () {
      expect(_store().unreadMessageCount, 2);
    });
  });

  group('search history', () {
    test('recordSearch keeps the newest term first and ignores blanks', () {
      final store = _store();

      store.recordSearch('plumbing');
      store.recordSearch('   ');
      store.recordSearch('cleaning');

      expect(store.recentSearches, ['cleaning', 'plumbing']);
    });

    test('recordSearch deduplicates case-insensitively', () {
      final store = _store();

      store.recordSearch('Cleaning');
      store.recordSearch('cleaning');

      expect(store.recentSearches, ['cleaning']);
    });

    test('recordSearch caps the history at maxRecentSearches', () {
      final store = _store();

      for (var i = 1; i <= AppStore.maxRecentSearches + 3; i++) {
        store.recordSearch('query $i');
      }

      expect(store.recentSearches, hasLength(AppStore.maxRecentSearches));
      expect(store.recentSearches.first, 'query 8');
      expect(store.recentSearches, isNot(contains('query 1')));
    });

    test('clearRecentSearches empties the history', () {
      final store = _store()..recordSearch('plumbing');

      store.clearRecentSearches();

      expect(store.recentSearches, isEmpty);
    });
  });

  group('theme mode', () {
    test('defaults to light and follows setThemeMode', () {
      final store = _store();

      expect(store.themeMode, ThemeMode.light);

      store.setThemeMode(ThemeMode.system);
      expect(store.themeMode, ThemeMode.system);
    });

    test('setThemeMode is a no-op when the mode is unchanged', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.setThemeMode(ThemeMode.light);

      expect(notifications, 0);
    });

    test('toggleTheme flips between light and dark', () {
      final store = _store();

      store.toggleTheme();
      expect(store.themeMode, ThemeMode.dark);

      store.toggleTheme();
      expect(store.themeMode, ThemeMode.light);
    });

    test('toggleTheme resolves the system mode against OS brightness', () {
      final store = _store()..setThemeMode(ThemeMode.system);

      store.toggleTheme(platformBrightness: Brightness.dark);

      expect(store.themeMode, ThemeMode.light);
    });
  });
}
