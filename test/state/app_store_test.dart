import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fundilink_app/data/mock_data.dart';
import 'package:fundilink_app/models/booking.dart';
import 'package:fundilink_app/models/chat.dart';
import 'package:fundilink_app/models/address.dart';
import 'package:fundilink_app/models/customer.dart';
import 'package:fundilink_app/models/fundi.dart';
import 'package:fundilink_app/state/app_store.dart';
import 'package:fundilink_app/state/key_value_store.dart';

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

  group('message threads', () {
    test('seeds a thread per demo conversation, oldest first', () {
      final store = _store();

      final grace = store.messagesFor('Grace Wanjiku');

      expect(grace, hasLength(3));
      expect(grace.first.text, 'Hello! Are you available tomorrow?');
      expect(grace.last.text, 'I will be there in 20 minutes 🙂');
      for (var i = 0; i < grace.length - 1; i++) {
        expect(grace[i].sentAt.isBefore(grace[i + 1].sentAt), isTrue);
      }
    });

    test('unknown contacts have an empty thread', () {
      expect(_store().messagesFor('Nobody'), isEmpty);
    });

    test('threads cannot be mutated by callers', () {
      final store = _store();

      expect(
        () => store.messagesFor('Grace Wanjiku').clear(),
        throwsUnsupportedError,
      );
    });

    test('sendMessage appends to the thread and persists it', () {
      final storage = InMemoryKeyValueStore();
      final store = AppStore(storage: storage);

      store.sendMessage(contactName: 'Grace Wanjiku', text: 'Karibu');

      final sent = store.messagesFor('Grace Wanjiku').last;
      expect(sent.text, 'Karibu');
      expect(sent.author, ChatAuthor.customer);
      expect(storage.getString(AppStore.messagesKey), contains('Karibu'));
      expect(
        AppStore(storage: storage).messagesFor('Grace Wanjiku').last.text,
        'Karibu',
      );
    });

    test('sendMessage keeps unknown contacts out of the store', () {
      final store = _store();

      store.sendMessage(contactName: 'Nobody', text: 'Hello');

      expect(store.messagesFor('Nobody'), isEmpty);
    });

    test('every demo conversation has a matching thread', () {
      final store = AppStore();

      for (final chat in MockData.chats) {
        expect(
          store.messagesFor(chat.name),
          isNotEmpty,
          reason: '${chat.name} has no thread history',
        );
      }
    });
  });

  group('addresses', () {
    test('starts from the demo addresses', () {
      expect(_store().addresses, SavedAddress.demo);
      expect(_store().defaultAddress?.label, 'Home');
    });

    test('a new address is only default when the list was empty', () {
      final store = _store()
        ..removeAddress('address-home')
        ..removeAddress('address-office');

      store.addAddress(label: 'Gym', line: 'Sarit Centre, Westlands');
      expect(store.defaultAddress?.label, 'Gym');

      store.addAddress(label: 'Mum', line: 'Ngong Road, Nairobi');
      expect(store.defaultAddress?.label, 'Gym');
    });

    test('removing the default promotes another address', () {
      final store = _store()..removeAddress('address-home');

      expect(store.addresses, hasLength(1));
      expect(store.defaultAddress?.label, 'Office');
    });

    test('removing the last address leaves no default to report', () {
      final store = _store()
        ..removeAddress('address-home')
        ..removeAddress('address-office');

      expect(store.addresses, isEmpty);
      expect(store.defaultAddress, isNull);
    });

    test('makeDefaultAddress moves the flag to exactly one address', () {
      final store = _store();
      final office = store.addresses[1].id;

      store.makeDefaultAddress(office);

      expect(store.defaultAddress?.label, 'Office');
      expect(
        store.addresses.where((address) => address.isDefault),
        hasLength(1),
      );
    });

    test('makeDefaultAddress ignores unknown ids', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.makeDefaultAddress('missing');

      expect(notifications, 0);
      expect(store.defaultAddress?.label, 'Home');
    });

    test('persists additions and restores them', () {
      final storage = InMemoryKeyValueStore();
      AppStore(
        storage: storage,
      ).addAddress(label: 'Gym', line: 'Sarit Centre, Westlands');

      final restored = AppStore(storage: storage);

      expect(restored.addresses, hasLength(3));
      expect(restored.addresses.last.label, 'Gym');
    });

    test('ids stay unique across a restore', () {
      final storage = InMemoryKeyValueStore();
      final first = AppStore(storage: storage)
        ..addAddress(label: 'Gym', line: 'Sarit Centre, Westlands');
      final restored = AppStore(storage: storage)
        ..addAddress(label: 'Mum', line: 'Ngong Road, Nairobi');

      expect(
        restored.addresses.map((address) => address.id).toSet(),
        hasLength(restored.addresses.length),
        reason:
            'the restored address must not reuse ${first.addresses.last.id}',
      );
    });

    test('keeps the demo addresses when the payload is unreadable', () {
      final store = AppStore(
        storage: InMemoryKeyValueStore({AppStore.addressesKey: 'not json'}),
      );

      expect(store.addresses, SavedAddress.demo);
    });
  });

  group('profile', () {
    test('starts from the demo customer', () {
      expect(_store().profile, CustomerProfile.demo);
    });

    test('updateProfile saves the change and notifies', () {
      final storage = InMemoryKeyValueStore();
      final store = AppStore(storage: storage);
      var notifications = 0;
      store.addListener(() => notifications++);

      store.updateProfile(store.profile.copyWith(name: 'Amina Y'));

      expect(store.profile.name, 'Amina Y');
      expect(notifications, 1);
      expect(storage.getString(AppStore.profileKey), contains('Amina Y'));
    });

    test('updateProfile ignores identical details', () {
      final store = _store();
      var notifications = 0;
      store.addListener(() => notifications++);

      store.updateProfile(store.profile);

      expect(notifications, 0);
    });

    test('restores saved details', () {
      final storage = InMemoryKeyValueStore({
        AppStore.profileKey: jsonEncode(
          CustomerProfile.demo.copyWith(name: 'Saved Name').toJson(),
        ),
      });

      expect(AppStore(storage: storage).profile.name, 'Saved Name');
    });

    test('keeps the demo profile when the payload is unreadable', () {
      final store = AppStore(
        storage: InMemoryKeyValueStore({AppStore.profileKey: 'nonsense'}),
      );

      expect(store.profile, CustomerProfile.demo);
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

  group('persistence', () {
    /// Storage holding a previous session's state.
    InMemoryKeyValueStore savedState() {
      final previous = _store();
      return InMemoryKeyValueStore()
        ..setString(
          AppStore.bookingsKey,
          jsonEncode([for (final b in previous.bookings) b.toJson()]),
        )
        ..setString(
          AppStore.conversationsKey,
          jsonEncode([for (final c in previous.conversations) c.toJson()]),
        )
        ..setStrings(AppStore.recentSearchesKey, const ['plumbing'])
        ..setString(AppStore.themeModeKey, ThemeMode.dark.name);
    }

    test('restores saved state instead of the demo data', () {
      final store = AppStore(storage: savedState());

      expect(store.bookings, _store().bookings);
      expect(store.conversations, _store().conversations);
      expect(store.recentSearches, ['plumbing']);
      expect(store.themeMode, ThemeMode.dark);
    });

    test('an empty in-memory store keeps the seeded demo data', () {
      final store = AppStore(storage: InMemoryKeyValueStore());

      expect(store.bookings, MockData.bookings);
      expect(store.conversations, MockData.chats);
      expect(store.themeMode, ThemeMode.light);
    });

    test('stores bookings written through addBooking and cancelBooking', () {
      final storage = InMemoryKeyValueStore();
      final store = AppStore(storage: storage);

      store.addBooking(_booking(id: 'b9'));
      expect(storage.getString(AppStore.bookingsKey), contains('"id":"b9"'));

      store.cancelBooking('b9');
      final saved =
          jsonDecode(storage.getString(AppStore.bookingsKey)!) as List;
      expect((saved.first as Map)['status'], BookingStatus.cancelled.name);
    });

    test('stores the chat preview when a message is sent', () {
      final storage = InMemoryKeyValueStore();
      final store = AppStore(storage: storage);

      store.sendMessage(contactName: 'Grace Wanjiku', text: 'Karibu');

      final saved =
          jsonDecode(storage.getString(AppStore.conversationsKey)!) as List;
      expect((saved.first as Map)['lastMessage'], 'Karibu');
    });

    test('stores the search history as it changes', () {
      final storage = InMemoryKeyValueStore();
      final store = AppStore(storage: storage);

      store.recordSearch('plumbing');
      expect(storage.getStrings(AppStore.recentSearchesKey), ['plumbing']);

      store.clearRecentSearches();
      expect(storage.getStrings(AppStore.recentSearchesKey), isEmpty);
    });

    test('stores the theme mode', () {
      final storage = InMemoryKeyValueStore();

      AppStore(storage: storage).setThemeMode(ThemeMode.dark);

      expect(storage.getString(AppStore.themeModeKey), 'dark');
    });

    test('a store without storage still works and writes nothing', () {
      final store = _store()..addBooking(_booking(id: 'b9'));

      expect(store.bookings.first.id, 'b9');
    });

    test('falls back to the seed data when the payload is unreadable', () {
      final store = AppStore(
        storage: InMemoryKeyValueStore({
          AppStore.bookingsKey: '{not json',
          AppStore.conversationsKey: '"a string, not a list"',
        }),
      );

      expect(store.bookings, MockData.bookings);
      expect(store.conversations, MockData.chats);
    });

    test('falls back when a saved enum name is no longer valid', () {
      final store = AppStore(
        storage: InMemoryKeyValueStore({
          AppStore.bookingsKey: jsonEncode([
            {..._booking().toJson(), 'status': 'retired'},
          ]),
        }),
      );

      expect(store.bookings, MockData.bookings);
    });

    test('an unknown theme mode name keeps the default', () {
      final store = AppStore(
        storage: InMemoryKeyValueStore({AppStore.themeModeKey: 'sepia'}),
      );

      expect(store.themeMode, ThemeMode.light);
    });
  });
}
