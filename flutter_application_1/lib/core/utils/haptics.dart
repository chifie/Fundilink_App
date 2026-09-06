import 'package:flutter/services.dart';

/// Thin, consistent wrappers around [HapticFeedback].
class Haptics {
  Haptics._();

  /// Light tap for button presses and small confirmations.
  static Future<void> light() => HapticFeedback.lightImpact();

  /// Medium tap for primary actions such as submitting a request.
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// Heavier tap for status changes and completions.
  static Future<void> strong() => HapticFeedback.heavyImpact();
}