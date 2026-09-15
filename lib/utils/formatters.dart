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

  /// Formats a shilling amount without decimals, e.g. `KSh 1,800`.
  ///
  /// Fundi rates and booking prices are always whole shillings, so grouping
  /// thousands keeps long numbers scannable on narrow cards.
  static String currency(num amount) => _currency.format(amount);
}
