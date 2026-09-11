import 'package:flutter/material.dart';

import 'app_elevation.dart';
import 'app_shapes.dart';

/// Material 3 card styles for the FundiLink design system.
///
/// Implements the three M3 card variants – elevated, filled and outlined –
/// with M3 corner radii (12dp for cards, 16dp for large media cards) and
/// the M3 elevation ladder. All variants are derived from the active
/// [ColorScheme] so light and dark stay consistent.
class AppCardStyles {
  AppCardStyles._();

  // Shared metrics from the M3 spec.
  static const EdgeInsets contentPadding = EdgeInsets.all(16);

  /// Compact padding for dense list-style cards.
  static const EdgeInsets compactPadding = EdgeInsets.all(12);

  // ---- Elevated card ----------------------------------------------------

  /// Elevated card: shadow lift over the surface color.
  static CardThemeData elevated(ColorScheme scheme) => CardThemeData(
        color: scheme.surfaceContainerLow,
        shadowColor: AppElevation.shadowColor,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.level1,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.md),
      );

  // ---- Filled card ------------------------------------------------------

  /// Filled card: tonal fill, no shadow – the default M3 look.
  static CardThemeData filled(ColorScheme scheme) => CardThemeData(
        color: scheme.surfaceContainerHighest,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.md),
      );

  // ---- Outlined card ----------------------------------------------------

  /// Outlined card: hairline border, flat fill for dense layouts.
  static CardThemeData outlined(ColorScheme scheme) => CardThemeData(
        color: scheme.surface,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.md,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      );

  // ---- Large media card -------------------------------------------------

  /// Large card variant with bigger corners for media-forward layouts.
  static CardThemeData large(ColorScheme scheme) => CardThemeData(
        color: scheme.surfaceContainerLow,
        shadowColor: AppElevation.shadowColor,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.level1,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: AppShapes.lg),
      );

  // ---- Widget-level theme data -------------------------------------------

  /// Builds the elevated card theme (Flutter's default [Card]).
  static CardThemeData elevatedTheme(ColorScheme scheme) => elevated(scheme);

  // ---- Decoration helpers -------------------------------------------------

  /// Filled-card [BoxDecoration] for containers that cannot use [Card].
  static BoxDecoration filledDecoration(ColorScheme scheme,
      {BorderRadius? borderRadius}) {
    return BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: borderRadius ?? AppShapes.md,
    );
  }

  /// Outlined-card [BoxDecoration] for containers that cannot use [Card].
  static BoxDecoration outlinedDecoration(ColorScheme scheme,
      {BorderRadius? borderRadius}) {
    return BoxDecoration(
      color: scheme.surface,
      borderRadius: borderRadius ?? AppShapes.md,
      border: Border.all(color: scheme.outlineVariant),
    );
  }

  /// Elevated-card [BoxDecoration] for containers that cannot use [Card].
  static BoxDecoration elevatedDecoration(
    ColorScheme scheme, {
    BorderRadius? borderRadius,
    double elevation = AppElevation.level1,
  }) {
    return BoxDecoration(
      color: scheme.surfaceContainerLow,
      borderRadius: borderRadius ?? AppShapes.md,
      boxShadow: AppElevation.shadows(elevation),
    );
  }
}
