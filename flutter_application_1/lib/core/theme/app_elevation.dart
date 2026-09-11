import 'package:flutter/material.dart';

/// Material 3 elevation tokens for the FundiLink design system.
///
/// M3 defines six elevation levels (0–5). Surfaces use elevation tints
/// rather than shadows in light mode; shadows are only applied from
/// level 3 upwards so the UI stays flat and calm.
class AppElevation {
  AppElevation._();

  /// Level 0 – page background, inline content.
  static const double level0 = 0.0;

  /// Level 1 – cards, switches, raised buttons on rest.
  static const double level1 = 1.0;

  /// Level 2 – app bars, hovered cards, tonal buttons raised.
  static const double level2 = 3.0;

  /// Level 3 – FABs, snackbars, menus, popups.
  static const double level3 = 6.0;

  /// Level 4 – navigation drawer (modal), hovered FABs.
  static const double level4 = 8.0;

  /// Level 5 – dialogs, navigation drawer (persistent).
  static const double level5 = 12.0;

  /// Shadow color used by all elevated surfaces.
  static const Color shadowColor = Color(0x33000000);

  /// Builds a soft M3-style shadow for a surface at the given elevation.
  static List<BoxShadow> shadows(double elevation, {Color? color}) {
    if (elevation <= 0) return const [];
    return [
      BoxShadow(
        color: color ?? shadowColor,
        blurRadius: elevation * 2,
        offset: Offset(0, elevation / 2),
      ),
    ];
  }
}
