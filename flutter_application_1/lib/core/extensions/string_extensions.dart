/// String extensions for common operations across the app.
extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncates the string to a maximum length with ellipsis.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}…';
  }

  /// Returns true if the string is a valid email format.
  bool get isValidEmail {
    return RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(this);
  }

  /// Returns initials from a full name (e.g. "James Otieno" → "JO").
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }
}
