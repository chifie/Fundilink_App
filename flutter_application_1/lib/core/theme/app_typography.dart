import 'package:flutter/material.dart';

/// Typography tokens for the FundiLink design system.
///
/// Defines the font families, weights and type-scale sizes used by
/// [AppTypography] to build the Material 3 text theme. Keep sizes aligned
/// with the M3 type scale (display 57/45/36, headline 32/28/24, title
/// 22/16/14, body 16/14/12, label 14/12/11).
class AppFonts {
  AppFonts._();

  /// Primary font family for the whole app.
  ///
  /// Falls back to the platform default (Roboto on Android, SF Pro on iOS)
  /// when the family is not bundled, which keeps text metrics predictable.
  static const String primary = 'Roboto';

  /// Font family for numeric code, token and currency text.
  static const String monospace = 'monospace';

  // Font weights – semantic names instead of raw numbers.
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Letter spacing from the M3 type scale.
  static const double trackingTight = -0.25;
  static const double trackingNormal = 0.0;
  static const double trackingWide = 0.15;
  static const double trackingWider = 0.25;
  static const double trackingWidest = 0.4;
  static const double trackingLabel = 0.5;

  /// Sizes for the M3 type scale roles.
  static const double displayLg = 57;
  static const double displayMd = 45;
  static const double displaySm = 36;
  static const double headlineLg = 32;
  static const double headlineMd = 28;
  static const double headlineSm = 24;
  static const double titleLg = 22;
  static const double titleMd = 16;
  static const double titleSm = 14;
  static const double bodyLg = 16;
  static const double bodyMd = 14;
  static const double bodySm = 12;
  static const double labelLg = 14;
  static const double labelMd = 12;
  static const double labelSm = 11;
}
