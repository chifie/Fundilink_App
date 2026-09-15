import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/booking.dart';
import '../models/chat.dart';
import '../models/fundi.dart';
import '../utils/formatters.dart';

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
    DateTime Function()? clock,
  }) : _fundis = <FundiProfile>[...(fundis ?? MockData.fundis)],
       _bookings = <Booking>[...(bookings ?? MockData.bookings)],
       _conversations = <Conversation>[...(conversations ?? MockData.chats)],
       // A public `themeMode` parameter reads better than exposing the
       // backing field as an initializing formal.
       // ignore: prefer_initializing_formals
       _themeMode = themeMode,
       _recentSearches = <String>[...recentSearches],
       _clock = clock ?? DateTime.now;

  /// Number of search terms kept for the search sheet's history.
  static const int maxRecentSearches = 5;

  final List<FundiProfile> _fundis;
  final List<Booking> _bookings;
  final List<Conversation> _conversations;
  final List<String> _recentSearches;
  final DateTime Function() _clock;
  ThemeMode _themeMode;

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
    notifyListeners();
  }

  /// Marks an active booking as cancelled. Completed jobs are left alone.
  void cancelBooking(String id) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1 || !_bookings[index].isActive) return;
    _bookings[index] = _bookings[index].copyWith(
      status: BookingStatus.cancelled,
    );
    notifyListeners();
  }

  /// Advances the progress tracker of a booking that is still active.
  void advanceBooking(String id, RequestStep step) {
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1 || !_bookings[index].isActive) return;
    _bookings[index] = _bookings[index].copyWith(step: step);
    notifyListeners();
  }

  // ------------------------------------------------------------ conversations

  /// Chat threads, in the order the fundis replied.
  List<Conversation> get conversations => List.unmodifiable(_conversations);

  /// Total unread messages across every thread.
  int get unreadMessageCount =>
      _conversations.fold(0, (total, chat) => total + chat.unreadCount);

  /// Appends an outgoing message to a thread by bumping its preview.
  ///
  /// Blank messages are ignored so an empty composer cannot create a thread
  /// entry with no content.
  void sendMessage({required String contactName, required String text}) {
    final message = text.trim();
    if (message.isEmpty) return;

    final index = _conversations.indexWhere((c) => c.name == contactName);
    if (index == -1) return;

    _conversations[index] = _conversations[index].copyWith(
      lastMessage: message,
      timeLabel: Formatters.timeOfDay(_clock()),
      unreadCount: 0,
    );
    notifyListeners();
  }

  /// Clears the unread badge for one thread.
  void markConversationRead(String contactName) {
    final index = _conversations.indexWhere((c) => c.name == contactName);
    if (index == -1 || !_conversations[index].hasUnread) return;

    _conversations[index] = _conversations[index].copyWith(unreadCount: 0);
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
    notifyListeners();
  }

  /// Forgets the whole search history.
  void clearRecentSearches() {
    if (_recentSearches.isEmpty) return;
    _recentSearches.clear();
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
    notifyListeners();
  }
}
