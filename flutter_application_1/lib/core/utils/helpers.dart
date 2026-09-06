/// Miscellaneous shared helpers used across the app.
class Helpers {
  Helpers._();

  /// Returns up to two initials from a full name, e.g. "James Otieno" -> "JO".
  static String initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// Maps a name to a stable color for initials avatars.
  static int colorSeed(String name) =>
      name.codeUnits.fold(0, (acc, c) => acc + c);

  /// A short "KES 0" amount keyed by total, used in copy strings.
  static String shortAmount(double amount) {
    if (amount >= 1000000) return '${(amount / 1000000).toStringAsFixed(1)}M';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}K';
    return amount.toStringAsFixed(0);
  }
}
