import 'package:flutter/material.dart';

/// Material 3 design system for the app.
///
/// Colors, component themes (buttons, cards, FAB) and typography are all
/// defined here so widgets only ever read from `Theme.of(context)`.
abstract final class AppTheme {
  /// Brand font family.
  ///
  /// Set this to a font declared in pubspec.yaml (`fonts:` section) or one
  /// provided by a package such as google_fonts. `null` keeps the platform
  /// default (Roboto on Android, SF Pro on iOS/macOS, Segoe UI on Windows).
  static const String? fontFamily = null;

  /// Seed color used to generate both color schemes.
  static const Color _seed = Colors.deepPurple;

  /// Light color scheme generated from the seed color.
  static ColorScheme get lightScheme => ColorScheme.fromSeed(seedColor: _seed);

  /// Dark color scheme generated from the seed color.
  static ColorScheme get darkScheme =>
      ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark);

  static ThemeData light() => _theme(lightScheme);

  static ThemeData dark() => _theme(darkScheme);

  static ThemeData _theme(ColorScheme colors) {
    final TextTheme textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      splashFactory: InkSparkle.splashFactory,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: textTheme.titleLarge,
      ),
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      // Cards: 12dp corners, tonal surface, subtle elevation.
      cardTheme: CardThemeData(
        color: colors.surfaceContainerLow,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        elevation: 3,
        highlightElevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Buttons: pill-shaped, 40dp tall, labelLarge text (M3 metrics).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: _buttonStyle(textTheme).copyWith(
          backgroundColor: WidgetStatePropertyAll(colors.primaryContainer),
          foregroundColor: WidgetStatePropertyAll(colors.onPrimaryContainer),
          elevation: const WidgetStatePropertyAll(0),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: _buttonStyle(textTheme).copyWith(
          backgroundColor: WidgetStatePropertyAll(colors.primary),
          foregroundColor: WidgetStatePropertyAll(colors.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: _buttonStyle(textTheme).copyWith(
          foregroundColor: WidgetStatePropertyAll(colors.primary),
          side: WidgetStatePropertyAll(BorderSide(color: colors.outline)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: _buttonStyle(textTheme).copyWith(
          foregroundColor: WidgetStatePropertyAll(colors.primary),
          padding:
              const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 12)),
        ),
      ),
    );
  }

  /// Shared Material 3 button metrics: 40dp minimum height, 64dp minimum
  /// width, full corner radius and the labelLarge text style.
  static ButtonStyle _buttonStyle(TextTheme text) => ButtonStyle(
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        minimumSize: const WidgetStatePropertyAll(Size(64, 40)),
        padding:
            const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 24)),
        textStyle: WidgetStatePropertyAll(text.labelLarge),
      );

  /// Material 3 type scale (15 styles) with spec sizes, weights, letter
  /// spacing and line heights. Colors are left to ThemeData so roles like
  /// onSurface/onSurfaceVariant resolve per brightness.
  static TextTheme _textTheme() => const TextTheme(
        displayLarge: TextStyle(
            fontSize: 57, height: 64 / 57, letterSpacing: -0.25),
        displayMedium: TextStyle(fontSize: 45, height: 52 / 45),
        displaySmall: TextStyle(fontSize: 36, height: 44 / 36),
        headlineLarge: TextStyle(fontSize: 32, height: 40 / 32),
        headlineMedium: TextStyle(fontSize: 28, height: 36 / 28),
        headlineSmall: TextStyle(fontSize: 24, height: 32 / 24),
        titleLarge: TextStyle(fontSize: 22, height: 28 / 22),
        titleMedium: TextStyle(
            fontSize: 16,
            height: 24 / 16,
            letterSpacing: 0.15,
            fontWeight: FontWeight.w500),
        titleSmall: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 16, height: 24 / 16, letterSpacing: 0.5),
        bodyMedium:
            TextStyle(fontSize: 14, height: 20 / 14, letterSpacing: 0.25),
        bodySmall: TextStyle(fontSize: 12, height: 16 / 12, letterSpacing: 0.4),
        labelLarge: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            letterSpacing: 0.1,
            fontWeight: FontWeight.w500),
        labelMedium: TextStyle(
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500),
        labelSmall: TextStyle(
            fontSize: 11,
            height: 16 / 11,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500),
      );
}
