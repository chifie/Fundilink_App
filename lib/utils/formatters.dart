import 'package:intl/intl.dart';

/// Presentation helpers for numbers and dates.
///
/// Keeping them in one place means prices and timestamps read the same
/// everywhere in the app and can be unit tested or localised in isolation.
abstract final class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'en',
    symbol: 'KSh ',
    decimalDigits: 0,
  );

  // Locale is left to intl's bundled default (en_US): naming a locale
  // explicitly would require initializeDateFormatting at startup.
  static final DateFormat _dayMonth = DateFormat('MMM d');
  static final DateFormat _timeOfDay = DateFormat('h:mm a');
  static final DateFormat _longDate = DateFormat('EEE, MMM d, y');

  /// Formats a shilling amount without decimals, e.g. `KSh 1,800`.
  ///
  /// Fundi rates and booking prices are always whole shillings, so grouping
  /// thousands keeps long numbers scannable on narrow cards.
  static String currency(num amount) => _currency.format(amount);

  /// Formats the calendar day, e.g. `Sep 20`.
  static String dayMonth(DateTime date) => _dayMonth.format(date);

  /// Formats the clock time, e.g. `2:00 PM`.
  static String timeOfDay(DateTime date) => _timeOfDay.format(date);

  /// Combines day and time for compact summaries, e.g. `Sep 20 · 2:00 PM`.
  static String dateTime(DateTime date) =>
      '${dayMonth(date)} · ${timeOfDay(date)}';

  /// Spells the day out for detail views, e.g. `Sat, Sep 20, 2026`.
  static String fullDate(DateTime date) => _longDate.format(date);
}
