/// Phone number formatting utilities.
class PhoneFormatter {
  PhoneFormatter._();

  /// Formats a Kenyan phone number for display (e.g. "+254711223344" → "+254 711 223 344").
  ///
  /// Returns the input unchanged if it does not match a recognised Kenyan
  /// or local-only format.
  static String format(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('+254') && cleaned.length == 13) {
      return '+254 ${cleaned.substring(4, 7)} ${cleaned.substring(7, 10)} ${cleaned.substring(10)}';
    }
    if (cleaned.startsWith('0') && cleaned.length == 10) {
      return '0${cleaned.substring(1, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
    }
    return phone;
  }

  /// Returns a masked phone number for privacy (e.g. "+254711****44").
  static String mask(String phone) {
    if (phone.length < 8) return phone;
    final start = phone.substring(0, 6);
    final end = phone.substring(phone.length - 2);
    return '$start****$end';
  }
}
