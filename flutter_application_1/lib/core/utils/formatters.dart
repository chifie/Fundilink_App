import 'package:intl/intl.dart';

import '../extensions/datetime_extensions.dart';

/// Display helpers for currency, dates and relative time.
class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat.currency(
    symbol: 'KES ',
    decimalDigits: 0,
  );

  static final DateFormat _date = DateFormat('MMM d, yyyy');
  static final DateFormat _shortDate = DateFormat('MMM d');
  static final DateFormat _time = DateFormat('h:mm a');

  static String currency(double amount) => _currency.format(amount);

  static String date(DateTime date) => _date.format(date);

  static String shortDate(DateTime date) => _shortDate.format(date);

  static String time(DateTime date) => _time.format(date);

  static String dateTime(DateTime date) =>
      '${_shortDate.format(date)} · ${_time.format(date)}';

  /// Compact human-friendly relative time, e.g. "2h ago", "1w ago".
  ///
  /// Delegates to [DateTimeExtensions.timeAgo] so all relative-time labels
  /// come from one implementation.
  static String timeAgo(DateTime date) => date.timeAgo;
}
