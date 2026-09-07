import 'package:flutter/material.dart';

/// Utility functions for common color operations.
class ColorUtils {
  /// Creates a color with simplified alpha value (0-100 scale).
  static Color withAlpha(Color color, int alpha) {
    assert(alpha >= 0 && alpha <= 100,
        'Alpha must be between 0 and 100, got $alpha');
    return color.withValues(alpha: alpha / 100);
  }

  /// Darkens a color by a given amount (0.0-1.0).
  static Color darken(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0,
        'Amount must be between 0.0 and 1.0, got $amount');
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Lightens a color by a given amount (0.0-1.0).
  static Color lighten(Color color, double amount) {
    assert(amount >= 0.0 && amount <= 1.0,
        'Amount must be between 0.0 and 1.0, got $amount');
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Blends two colors together with a given weight.
  static Color blend(Color color1, Color color2, double weight) {
    assert(weight >= 0.0 && weight <= 1.0,
        'Weight must be between 0.0 and 1.0, got $weight');
    final inverseWeight = 1.0 - weight;
    return Color.fromARGB(
      (color1.a * weight + color2.a * inverseWeight).round(),
      (color1.r * weight + color2.r * inverseWeight).round(),
      (color1.g * weight + color2.g * inverseWeight).round(),
      (color1.b * weight + color2.b * inverseWeight).round(),
    );
  }

  /// Checks if a color is light (for determining text color).
  static bool isLight(Color color) {
    final brightness = color.computeLuminance();
    return brightness > 0.5;
  }

  /// Gets an appropriate text color (black or white) for a background.
  static Color textOn(Color backgroundColor) {
    return isLight(backgroundColor) ? Colors.black : Colors.white;
  }

  /// Creates a gradient from a single color (solid gradient).
  static LinearGradient solid(Color color) {
    return LinearGradient(colors: [color, color]);
  }

  /// Creates a gradient from a list of colors with default direction.
  static LinearGradient defaultGradient(List<Color> colors) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}
