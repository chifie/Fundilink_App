import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/chat.dart';
import '../models/customer.dart';
import '../models/fundi.dart';
import '../models/notification.dart';
import '../utils/formatters.dart';
import 'key_value_store.dart';

/// Single source of truth for everything the customer can see or change.
///
/// Seeded from [MockData] until a backend exists, and mutable through the
/// methods below so screens never edit shared lists in place. Widgets listen
/// with `context.watch<AppStore>()` and rebuild when [notifyListeners] runs.
class AppStore extends ChangeNotifier {
  AppStore({
    List<FundiProfile>? fundis,
    List<Booking>? bookings,
    List<Conversation>? conversations,
    ThemeMode themeMode = ThemeMode.light,
    List<String> recentSearches = const <String>[],
    KeyValueStore? storage,
    DateTime Function()? clock,
  }) : _fundis = <FundiProfile>[...(fundis ?? MockData.fundis)],
       _bookings = <Booking>[...(bookings ?? MockData.bookings)],
       _conversations = <Conversation>[...(conversations ?? MockData.chats)],
       // ignore: prefer_initializing_formals
       _themeMode = themeMode,
       _recentSearches = <String>[...recentSearches],
       // Named parameters cannot be private, so both the public `themeMode`
       // and `storage` parameters are assigned rather than taken as
       // initializing formals.
       // ignore: prefer_initializing_formals
       _storage = storage,
       _clock = clock ?? DateTime.now {
    _restore();
  }

  /// Number of search terms kept for the search sheet's history.
  static const int maxRecentSearches = 5;

  /// Storage keys, public so tests and migrations share one source of truth.
  static const String themeModeKey = 'theme_mode';
  static const String bookingsKey = 'bookings';
  static const String conversationsKey = 'conversations';
  static const String recentSearchesKey = 'recent_searches';
  static const String profileKey = 'profile';
  static const String addressesKey = 'addresses';
  static const String messagesKey = 'messages';

  final List<FundiProfile> _fundis;
  final List<Booking> _bookings;
  final List<Conversation> _conversations;
  final List<String> _recentSearches;
  final DateTime Function() _clock;

  /// Local storage, or null when the store should stay in memory only.
  final KeyValueStore? _storage;
  ThemeMode _themeMode;

  /// Starts from the demo profile and is replaced by saved details, if any.
  CustomerProfile _profile = CustomerProfile.demo;

  final List<SavedAddress> _addresses = [...SavedAddress.demo];

  /// Thread history per contact, oldest message first.
  final Map<String, List<ChatMessage>> _messages = {
    for (final entry in MockData.messages.entries) entry.key: [...entry.value],
  };

  /// Counter behind new address ids, kept above the restored ids so an id
  /// is never reused across launches.
  int _nextAddressId = 0;

  /// Same idea for booking ids.
  int _nextBookingId = 0;

  // ---------------------------------------------------------------- catalogue

  /// Every fundi in the catalogue, in catalogue order.
  List<FundiProfile> get fundis => List.unmodifiable(_fundis);

  /// The three best-rated fundis, for the home tab's highlight list.
  List<FundiProfile> get topRatedFundis {
    final ranked = [..._fundis]
      ..sort((a, b) {
        final byRating = b.rating.compareTo(a.rating);
        return byRating != 0
            ? byRating
            : b.reviewCount.compareTo(a.reviewCount);
      });
    return List.unmodifiable(ranked.take(3));
  }

  /// Looks a fundi up by name, or returns null when unknown.
  FundiProfile? fundiByName(String name) {
    for (final fundi in _fundis) {
      if (fundi.name == name) return fundi;
    }
    return null;
  }

  /// Replaces a fundi record, e.g. after a rating or availability change.
  void updateFundi(FundiProfile fundi) {
    final index = _fundis.indexWhere((f) => f.name == fundi.name);
    if (index == -1) return;
    _fundis[index] = fundi;
    notifyListeners();
  }

  // ----------------------------------------------------------------- bookings

  /// All bookings, newest first.
  List<Booking> get bookings => List.unmodifiable(_bookings);

  /// Bookings in the given lifecycle stage, newest first.
  List<Booking> bookingsWithStatus(BookingStatus status) =>
      List.unmodifiable(_bookings.where((b) => b.status == status));

  /// Customer-facing active queue. These are requests still needing attention.
  List<Booking> get activeBookings =>
      List.unmodifiable(_bookings.where((b) => b.isActive));

  /// Jobs a fundi would see in their dashboard, newest first.
  List<Booking> get fundiJobs =>
      List.unmodifiable(_bookings.where((b) => b.isFundiActionable));

  /// Requests waiting for the fundi to accept or reject.
  List<Booking> get pendingRequests => List.unmodifiable(
    _bookings.where((b) => b.status == BookingStatus.pending),
  );

  /// Jobs that have been accepted but are not finished yet.
  List<Booking> get upcomingJobs => List.unmodifiable(
    _bookings.where((b) => b.status == BookingStatus.accepted),
  );

  /// Jobs currently moving or being worked on.
  List<Booking> get jobsInProgress => List.unmodifiable(
    _bookings.where(
      (b) =>
          b.status == BookingStatus.onTheWay ||
          b.status == BookingStatus.inProgress ||
          b.status == BookingStatus.active,
    ),
  );

  /// Jobs completed by the fundi, including those awaiting payment.
  List<Booking> get completedJobs => List.unmodifiable(
    _bookings.where(
      (b) =>
          b.status == BookingStatus.completed ||
          b.status == BookingStatus.paymentPending ||
          b.status == BookingStatus.paid ||
          b.status == BookingStatus.rated,
    ),
  );

  /// How many jobs are currently in flight.
  int get activeBookingCount => _bookings.where((b) => b.isActive).length;

  /// Simple local MVP earnings total from paid/rated jobs.
  int get totalEarnings => _bookings
      .where((b) => b.status == BookingStatus.paid || b.status == BookingStatus.rated)
      .fold(0, (sum, booking) => sum + booking.payableAmount);

  /// The best-rated fundi offering [skill], or null when nobody does yet.
  FundiProfile? bestFundiFor(FundiSkill skill) {
    final matches = _fundis.where((fundi) => fundi.skill == skill).toList()
      ..sort((a, b) {
        final byRating = b.rating.compareTo(a.rating);
        return byRating != 0 ? byRating : b.jobsDone.compareTo(a.jobsDone);
      });
    return matches.isEmpty ? null : matches.first;
  }

  /// Creates a service request and stores it, returning the new booking.
  ///
  /// Returns null when no fundi offers the skill. The fundi is matched
  /// automatically until customers can choose one themselves.
  Booking? requestService({
    required FundiSkill skill,
    required String description,
    DateTime? scheduledAt,
    String? location,
    String? notes,
  }) {
    final fundi = bestFundiFor(skill);
    if (fundi == null) return null;

    return bookFundi(
      fundi,
      service: description,
      scheduledAt: scheduledAt,
      location: location,
      notes: notes,
    );
  }

  /// Books [fundi] directly, for a customer who already picked one.
  Booking bookFundi(
    FundiProfile fundi, {
    String? service,
    DateTime? scheduledAt,
    String? location,
    String? notes,
  }) {
    final booking = Booking(
      id: 'booking-${_nextBookingId++}',
      fundi: fundi,
      service: service ?? '${fundi.skill.label} job',
      scheduledAt: scheduledAt ?? _nextMorning(),
      price: fundi.pricePerHour,
      status: BookingStatus.pending,
      step: RequestStep.requested,
      location: location ?? defaultAddress?.line ?? _profile.location,
      notes: notes ?? '',
    );
    _bookings.insert(0, booking);
    _persistBookings();
    notifyListeners();
    return booking;
  }

  /// Tomorrow at 09:00, the slot a request defaults to when none is picked.
  DateTime _nextMorning() {
    final now = _clock();
    return DateTime(now.year, now.month, now.day + 1, 9);
  }

  /// Stores a new request at the top of the list.
  void addBooking(Booking booking) {
    _bookings.insert(0, booking);
    _persistBookings();
    notifyListeners();
  }

  /// Marks an active booking as cancelled. Completed jobs are left alone.
  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1 || !_bookings[index].isActive) return;
    _bookings[index] = _bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    _persistBookings();
    notifyListeners();
  }

  /// Fundi accepts a pending customer request.
  void acceptBooking(String id) {
    _updateBooking(id, (booking) {
      if (booking.status != BookingStatus.pending) return booking;
      return booking.copyWith(
        status: BookingStatus.accepted,
        step: RequestStep.accepted,
      );
    });
  }

  /// Fundi rejects a pending customer request.
  void rejectBooking(String id) {
    _updateBooking(id, (booking) {
      if (booking.status != BookingStatus.pending) return booking;
      return booking.copyWith(status: BookingStatus.rejected);
    });
  }

  /// Moves an accepted job through the fundi-side work stages.
  void updateBookingStatus(String id, BookingStatus status) {
    final allowed = {
      BookingStatus.onTheWay,
      BookingStatus.inProgress,
      BookingStatus.completed,
    };
    if (!allowed.contains(status)) return;

    _updateBooking(id, (booking) {
      final canMove = switch ((booking.status, status)) {
        (BookingStatus.accepted, BookingStatus.onTheWay) => true,
        (BookingStatus.onTheWay, BookingStatus.inProgress) => true,
        (BookingStatus.inProgress, BookingStatus.completed) => true,
        (BookingStatus.active, BookingStatus.onTheWay) => true,
        _ => false,
      };
      if (!canMove) return booking;
      return booking.copyWith(
        status: status,
        step: switch (status) {
          BookingStatus.onTheWay => RequestStep.accepted,
          BookingStatus.inProgress => RequestStep.inProgress,
          BookingStatus.completed => RequestStep.done,
          _ => booking.step,
        },
      );
    });
  }

  /// Fundi completes a job and records the simple MVP invoice.
  void completeJob({
    required String id,
    required String workCompleted,
    required int labourCost,
    required int materialCost,
  }) {
    final total = labourCost + materialCost;
    _updateBooking(id, (booking) {
      if (booking.status != BookingStatus.inProgress) return booking;
      return booking.copyWith(
        status: BookingStatus.paymentPending,
        step: RequestStep.done,
        workCompleted: workCompleted.trim(),
        labourCost: labourCost,
        materialCost: materialCost,
        totalAmount: total,
        price: total == 0 ? booking.price : total,
      );
    });
  }

  /// Customer marks the simple local MVP payment as done.
  void markPaid(String id, String method) {
    _updateBooking(id, (booking) {
      if (booking.status != BookingStatus.paymentPending) return booking;
      return booking.copyWith(status: BookingStatus.paid, paymentMethod: method);
    });
  }

  /// Customer rates the fundi after payment.
  void rateBooking({required String id, required int rating, String review = ''}) {
    _updateBooking(id, (booking) {
      if (booking.status != BookingStatus.paid) return booking;
      return booking.copyWith(
        status: BookingStatus.rated,
        rating: rating.clamp(1, 5),
        review: review.trim(),
      );
    });
  }

  void _updateBooking(String id, Booking Function(Booking booking) update) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) return;
    final next = update(_bookings[index]);
    if (next == _bookings[index]) return;
    _bookings[index] = next;
    _persistBookings();
    notifyListeners();
  }

  /// Advances the progress tracker of a booking that is still active.
  void advanceBooking(String id, RequestStep step) {
    _updateBooking(id, (booking) {
      if (!booking.isActive) return booking;
      return booking.copyWith(step: step);
    });
  }

  // ------------------------------------------------------------ conversations

  /// Chat threads, in the order the fundis replied.
  List<Conversation> get conversations => List.unmodifiable(_conversations);

  /// Total unread messages across every thread.
  int get unreadMessageCount =>
      _conversations.fold(0, (total, chat) => total + chat.unreadCount);

  /// Appends an outgoing message to a thread and updates its preview.
  ///
  /// Blank messages are ignored so an empty composer cannot create a thread
  /// entry with no content.
  void sendMessage({required String contactName, required String text}) {
    final message = text.trim();
    if (message.isEmpty) return;

    final index = _conversations.indexWhere((c) => c.name == contactName);
    if (index == -1) return;

    final sentAt = _clock();
    _conversations[index] = _conversations[index].copyWith(
      lastMessage: message,
      timeLabel: Formatters.timeOfDay(sentAt),
      unreadCount: 0,
    );
    _messages
        .putIfAbsent(contactName, () => <ChatMessage>[])
        .add(
          ChatMessage(
            text: message,
            sentAt: sentAt,
            author: ChatAuthor.customer,
          ),
        );

    _persistConversations();
    _persistMessages();
    notifyListeners();
  }

  /// The thread with [contactName], oldest message first.
  ///
  /// Unknown contacts return an empty thread rather than throwing, so a
  /// deleted conversation cannot crash the chat room.
  List<ChatMessage> messagesFor(String contactName) =>
      List.unmodifiable(_messages[contactName] ?? const <ChatMessage>[]);

  /// Clears the unread badge for one thread.
  void markConversationRead(String contactName) {
    final index = _conversations.indexWhere((c) => c.name == contactName);
    if (index == -1 || !_conversations[index].hasUnread) return;

    _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
    _persistConversations();
    notifyListeners();
  }

  // ------------------------------------------------------------------- search

  /// Most recent search terms, newest first.
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  /// Remembers a term, ignoring blanks and duplicates.
  void recordSearch(String query) {
    final term = query.trim();
    if (term.isEmpty) return;

    _recentSearches
      ..removeWhere((existing) => existing.toLowerCase() == term.toLowerCase())
      ..insert(0, term);
    if (_recentSearches.length > maxRecentSearches) {
      _recentSearches.removeRange(maxRecentSearches, _recentSearches.length);
    }
    _persistRecentSearches();
    notifyListeners();
  }

  /// Forgets the whole search history.
  void clearRecentSearches() {
    if (_recentSearches.isEmpty) return;
    _recentSearches.clear();
    _persistRecentSearches();
    notifyListeners();
  }

  // ----------------------------------------------------------- notifications

  /// Activity worth surfacing on the home tab, unread items first.
  List<AppNotification> get notifications {
    final items = <AppNotification>[];

    for (final chat in _conversations) {
      if (!chat.hasUnread) continue;
      items.add(
        AppNotification(
          id: 'message-${chat.name}',
          kind: NotificationKind.message,
          title: '${chat.name} sent you a message',
          detail: chat.lastMessage,
          contactName: chat.name,
          isUnread: true,
        ),
      );
    }

    for (final booking in _bookings) {
      final isAwaitingFundi = booking.status == BookingStatus.pending ||
          booking.step == RequestStep.requested;
      items.add(
        AppNotification(
          id: 'booking-${booking.id}',
          kind: switch (booking.status) {
            BookingStatus.rejected => NotificationKind.awaitingFundi,
            BookingStatus.cancelled => NotificationKind.awaitingFundi,
            BookingStatus.completed ||
            BookingStatus.paymentPending ||
            BookingStatus.paid ||
            BookingStatus.rated => NotificationKind.completed,
            BookingStatus.pending =>
              NotificationKind.awaitingFundi,
            _ => NotificationKind.inProgress,
          },
          title: _notificationTitle(booking),
          detail: '${booking.service} · ${booking.dateLabel}',
          isUnread: isAwaitingFundi,
        ),
      );
    }

    items.sort((a, b) {
      if (a.isUnread == b.isUnread) return 0;
      return a.isUnread ? -1 : 1;
    });
    return List.unmodifiable(items);
  }

  /// Number of notifications the customer has not caught up with.
  int get unreadNotificationCount =>
      notifications.where((item) => item.isUnread).length;

  String _notificationTitle(Booking booking) {
    if (booking.status == BookingStatus.completed) {
      return '${booking.fundi.name} finished your job';
    }
    if (booking.status == BookingStatus.paymentPending) {
      return 'Payment is pending for ${booking.service}';
    }
    if (booking.status == BookingStatus.paid) {
      return 'Payment received for ${booking.service}';
    }
    if (booking.status == BookingStatus.rated) {
      return 'Thanks for rating ${booking.fundi.name}';
    }
    if (booking.status == BookingStatus.rejected) {
      return '${booking.fundi.name} rejected your request';
    }
    if (booking.status == BookingStatus.cancelled) {
      return '${booking.service} was cancelled';
    }
    if (booking.status == BookingStatus.pending ||
        booking.step == RequestStep.requested) {
      return 'Waiting for a fundi to accept';
    }
    if (booking.status == BookingStatus.accepted) {
      return '${booking.fundi.name} accepted your request';
    }
    return '${booking.fundi.name} is on the way';
  }

  /// How long the stand-in catalogue refresh pretends to take.
  static const Duration refreshDelay = Duration(milliseconds: 600);

  /// Re-checks the catalogue for changes.
  ///
  /// There is no backend yet, so this waits a beat and notifies listeners
  /// once. It exists so pull-to-refresh has something honest to wait on
  /// rather than a spinner that lies about doing work.
  Future<void> refresh() async {
    await Future<void>.delayed(refreshDelay);
    notifyListeners();
  }

  // ------------------------------------------------------------------ profile

  /// The signed-in customer's details.
  CustomerProfile get profile => _profile;

  /// Saves edited profile details and remembers them for next launch.
  void updateProfile(CustomerProfile profile) {
    if (_profile == profile) return;
    _profile = profile;
    _storage?.setString(profileKey, jsonEncode(profile.toJson()));
    notifyListeners();
  }

  // --------------------------------------------------------------- addresses

  /// Places the customer can send a fundi to, in the order they were added.
  List<SavedAddress> get addresses => List.unmodifiable(_addresses);

  /// The address new bookings default to, or null when none is saved.
  SavedAddress? get defaultAddress => _addresses.isEmpty
      ? null
      : _addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => _addresses.first,
        );

  /// Adds a place, making it the default if it is the first one.
  void addAddress({required String label, required String line}) {
    _addresses.add(
      SavedAddress(
        id: 'address-${_nextAddressId++}',
        label: label,
        line: line,
        isDefault: _addresses.isEmpty,
      ),
    );
    _persistAddresses();
    notifyListeners();
  }

  /// Removes a place, promoting another one if it was the default.
  void removeAddress(String id) {
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index == -1) return;

    final removed = _addresses.removeAt(index);
    if (removed.isDefault && _addresses.isNotEmpty) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    _persistAddresses();
    notifyListeners();
  }

  /// Makes one place the default and clears the flag from the others.
  void makeDefaultAddress(String id) {
    final index = _addresses.indexWhere((address) => address.id == id);
    if (index == -1 || _addresses[index].isDefault) return;

    for (var i = 0; i < _addresses.length; i++) {
      _addresses[i] = _addresses[i].copyWith(isDefault: i == index);
    }
    _persistAddresses();
    notifyListeners();
  }

  // -------------------------------------------------------------------- theme

  /// Whether the app follows the system, light or dark scheme.
  ThemeMode get themeMode => _themeMode;

  /// Switches between the light and dark schemes.
  ///
  /// A store still following the system resolves against the OS brightness so
  /// the first tap always looks like it did something.
  void toggleTheme({Brightness platformBrightness = Brightness.light}) {
    final isDark = _themeMode == ThemeMode.system
        ? platformBrightness == Brightness.dark
        : _themeMode == ThemeMode.dark;
    setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }

  /// Sets the scheme preference explicitly.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    _storage?.setString(themeModeKey, mode.name);
    notifyListeners();
  }

  // --------------------------------------------------------------- persistence

  /// Replaces the seed data with anything saved by a previous run.
  ///
  /// A corrupt or outdated payload is skipped rather than thrown so a bad
  /// write can never stop the app from starting.
  void _restore() {
    final storage = _storage;
    if (storage == null) return;

    final bookings = _decodeList(
      storage.getString(bookingsKey),
      Booking.fromJson,
    );
    if (bookings != null) {
      _bookings
        ..clear()
        ..addAll(bookings);
      _nextBookingId = bookings.length;
    }

    final conversations = _decodeList(
      storage.getString(conversationsKey),
      Conversation.fromJson,
    );
    if (conversations != null) {
      _conversations
        ..clear()
        ..addAll(conversations);
    }

    final searches = storage.getStrings(recentSearchesKey);
    if (searches != null) {
      _recentSearches
        ..clear()
        ..addAll(searches);
    }

    final mode = storage.getString(themeModeKey);
    if (mode != null) {
      _themeMode = ThemeMode.values.asNameMap()[mode] ?? _themeMode;
    }

    final profile = storage.getString(profileKey);
    if (profile != null) {
      _profile = _decodeProfile(profile) ?? _profile;
    }

    final addresses = _decodeList(
      storage.getString(addressesKey),
      SavedAddress.fromJson,
    );
    if (addresses != null) {
      _addresses
        ..clear()
        ..addAll(addresses);
      _nextAddressId = addresses.length;
    }

    final messages = _decodeMessages(storage.getString(messagesKey));
    if (messages != null) {
      _messages
        ..clear()
        ..addAll(messages);
    }
  }

  static Map<String, List<ChatMessage>>? _decodeMessages(String? raw) {
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return {
        for (final entry in decoded.entries)
          if (entry.value is List)
            entry.key: [
              for (final item in entry.value as List)
                if (item is Map<String, dynamic>) ChatMessage.fromJson(item),
            ],
      };
    } catch (_) {
      // Unreadable payload: fall back to the seeded threads.
      return null;
    }
  }

  static CustomerProfile? _decodeProfile(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return CustomerProfile.fromJson(decoded);
    } catch (_) {
      // Unreadable payload: keep the demo profile.
      return null;
    }
  }

  static List<T>? _decodeList<T>(
    String? raw,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return null;
      return [
        for (final item in decoded)
          if (item is Map<String, dynamic>) fromJson(item),
      ];
    } catch (_) {
      // Unreadable payload: fall back to the seed data.
      return null;
    }
  }

  void _persistBookings() =>
      _persistList(bookingsKey, _bookings, (Booking b) => b.toJson());

  void _persistConversations() => _persistList(
    conversationsKey,
    _conversations,
    (Conversation c) => c.toJson(),
  );

  void _persistRecentSearches() =>
      _storage?.setStrings(recentSearchesKey, _recentSearches);

  void _persistAddresses() =>
      _persistList(addressesKey, _addresses, (SavedAddress a) => a.toJson());

  void _persistMessages() => _storage?.setString(
    messagesKey,
    jsonEncode({
      for (final entry in _messages.entries)
        entry.key: [for (final message in entry.value) message.toJson()],
    }),
  );

  void _persistList<T>(
    String key,
    List<T> items,
    Map<String, dynamic> Function(T) toJson,
  ) => _storage?.setString(
    key,
    jsonEncode([for (final item in items) toJson(item)]),
  );
}
