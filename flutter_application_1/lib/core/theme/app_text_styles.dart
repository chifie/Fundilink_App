import 'package:flutter/material.dart';

import 'app_typography.dart';

/// Material 3 type scale for the FundiLink design system.
///
/// Builds the three text themes Flutter uses (plain [TextTheme],
/// [TextTheme.apply] variants for primary/onSurface colors, and the
/// Material 3 roles: display, headline, title, body and label).
///
/// Every style pairs a size with the M3-recommended weight and letter
/// spacing so hierarchy reads consistently across screens.
class AppTextStyles {
  AppTextStyles._();

  // ---- Display ----------------------------------------------------------

  /// Largest display text – hero numerals and marketing moments.
  static TextStyle displayLarge(Color color) => TextStyle(
        fontSize: AppFonts.displayLg,
        fontWeight: AppFonts.regular,
        letterSpacing: AppFonts.trackingTight,
        color: color,
        height: 1.12,
      );

  /// Medium display text – large celebratory numbers.
  static TextStyle displayMedium(Color color) => TextStyle(
        fontSize: AppFonts.displayMd,
        fontWeight: AppFonts.regular,
        color: color,
        height: 1.16,
      );

  /// Smallest display text – compact hero headers.
  static TextStyle displaySmall(Color color) => TextStyle(
        fontSize: AppFonts.displaySm,
        fontWeight: AppFonts.regular,
        color: color,
        height: 1.22,
      );

  // ---- Headline ---------------------------------------------------------

  /// Largest headline – page titles on wide layouts.
  static TextStyle headlineLarge(Color color) => TextStyle(
        fontSize: AppFonts.headlineLg,
        fontWeight: AppFonts.regular,
        color: color,
        height: 1.25,
      );

  /// Medium headline – screen titles.
  static TextStyle headlineMedium(Color color) => TextStyle(
        fontSize: AppFonts.headlineMd,
        fontWeight: AppFonts.regular,
        color: color,
        height: 1.29,
      );

  /// Smallest headline – section and card headers.
  static TextStyle headlineSmall(Color color) => TextStyle(
        fontSize: AppFonts.headlineSm,
        fontWeight: AppFonts.regular,
        color: color,
        height: 1.33,
      );

  // ---- Title ------------------------------------------------------------

  /// Largest title – dialog and sheet titles.
  static TextStyle titleLarge(Color color) => TextStyle(
        fontSize: AppFonts.titleLg,
        fontWeight: AppFonts.medium,
        color: color,
        height: 1.27,
      );

  /// Medium title – list item titles and tab labels.
  static TextStyle titleMedium(Color color) => TextStyle(
        fontSize: AppFonts.titleMd,
        fontWeight: AppFonts.semiBold,
        letterSpacing: AppFonts.trackingWide,
        color: color,
        height: 1.5,
      );

  /// Smallest title – dense list titles and subtitles.
  static TextStyle titleSmall(Color color) => TextStyle(
        fontSize: AppFonts.titleSm,
        fontWeight: AppFonts.medium,
        letterSpacing: AppFonts.trackingWider,
        color: color,
        height: 1.43,
      );

  // ---- Body -------------------------------------------------------------

  /// Long-form body text.
  static TextStyle bodyLarge(Color color) => TextStyle(
        fontSize: AppFonts.bodyLg,
        fontWeight: AppFonts.regular,
        letterSpacing: AppFonts.trackingWider,
        color: color,
        height: 1.5,
      );

  /// Default body text for most UI copy.
  static TextStyle bodyMedium(Color color) => TextStyle(
        fontSize: AppFonts.bodyMd,
        fontWeight: AppFonts.regular,
        letterSpacing: AppFonts.trackingWider,
        color: color,
        height: 1.43,
      );

  /// Dense body text – captions and helper copy.
  static TextStyle bodySmall(Color color) => TextStyle(
        fontSize: AppFonts.bodySm,
        fontWeight: AppFonts.regular,
        letterSpacing: AppFonts.trackingWidest,
        color: color,
        height: 1.33,
      );

  // ---- Label ------------------------------------------------------------

  /// Button and prominent label text.
  static TextStyle labelLarge(Color color) => TextStyle(
        fontSize: AppFonts.labelLg,
        fontWeight: AppFonts.medium,
        letterSpacing: AppFonts.trackingWider,
        color: color,
        height: 1.43,
      );

  /// Secondary labels – badges, chips, tabs.
  static TextStyle labelMedium(Color color) => TextStyle(
        fontSize: AppFonts.labelMd,
        fontWeight: AppFonts.medium,
        letterSpacing: AppFonts.trackingLabel,
        color: color,
        height: 1.33,
      );

  /// Smallest labels – tags and tiny annotations.
  static TextStyle labelSmall(Color color) => TextStyle(
        fontSize: AppFonts.labelSm,
        fontWeight: AppFonts.medium,
        letterSpacing: AppFonts.trackingLabel,
        color: color,
        height: 1.45,
      );

  /// Builds the full Material 3 [TextTheme] for a given content color.
  static TextTheme textTheme(Color color) => TextTheme(
        displayLarge: displayLarge(color),
        displayMedium: displayMedium(color),
        displaySmall: displaySmall(color),
        headlineLarge: headlineLarge(color),
        headlineMedium: headlineMedium(color),
        headlineSmall: headlineSmall(color),
        titleLarge: titleLarge(color),
        titleMedium: titleMedium(color),
        titleSmall: titleSmall(color),
        bodyLarge: bodyLarge(color),
        bodyMedium: bodyMedium(color),
        bodySmall: bodySmall(color),
        labelLarge: labelLarge(color),
        labelMedium: labelMedium(color),
        labelSmall: labelSmall(color),
      );
}
