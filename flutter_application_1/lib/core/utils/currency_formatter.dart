/// Currency formatting utilities for the Kenyan Shilling.
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats a number as KES currency (e.g. 1200 → "KES 1,200").
  static String format(double amount) {
    final isNegative = amount < 0;
    final abs = amount.abs();
    final formatted = abs
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
    return '${isNegative ? '-' : ''}KES $formatted';
  }

  /// Short format for large amounts (e.g. 1500000 → "KES 1.5M").
  static String formatShort(double amount) {
    if (amount >= 1000000) {
      return 'KES ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return 'KES ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }

  /// Returns a compact amount without the KES prefix (e.g. 800 → "800").
  static String compact(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
