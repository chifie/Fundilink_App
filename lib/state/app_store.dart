import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/address.dart';
import '../models/booking.dart';
import '../models/chat.dart';
import '../models/customer.dart';
import '../models/fundi.dart';
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

  /// How many jobs are currently in flight.
  int get activeBookingCount => _bookings.where((b) => b.isActive).length;

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

  /// Advances the progress tracker of a booking that is still active.
  void advanceBooking(String id, RequestStep step) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1 || !_bookings[index].isActive) return;
    _bookings[index] = _bookings[index].copyWith(step: step);
    _persistBookings();
    notifyListeners();
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
