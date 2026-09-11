import 'package:flutter/material.dart';

/// Material 3 shape tokens for the FundiLink design system.
///
/// Mirrors the M3 shape scale: extra small for tiny components (chips,
/// text fields), small for buttons and snacks, medium for cards, large
/// for bottom sheets and dialogs, extra large for full-screen sheets.
class AppShapes {
  AppShapes._();

  // Corner radii from the M3 shape scale.
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 999.0;

  /// Extra small corners – text fields, chips, tags.
  static final BorderRadius xs = BorderRadius.circular(radiusXs);

  /// Small corners – segmented buttons, snackbars, toggles.
  static final BorderRadius sm = BorderRadius.circular(radiusSm);

  /// Medium corners – buttons, cards, menus, list tiles.
  static final BorderRadius md = BorderRadius.circular(radiusMd);

  /// Large corners – cards, dialogs, sheets.
  static final BorderRadius lg = BorderRadius.circular(radiusLg);

  /// Extra large corners – bottom sheets, full dialogs.
  static final BorderRadius xl = BorderRadius.circular(radiusXl);

  /// Fully rounded pill shape.
  static final BorderRadius full = BorderRadius.circular(radiusFull);

  /// Extra small rounded rectangle shape – chips, text fields.
  static const OutlinedBorder xsShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusXs)),
  );

  /// Small rounded rectangle shape – segmented buttons, snackbars.
  static const OutlinedBorder smShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusSm)),
  );

  /// Medium rounded rectangle shape – buttons, cards, menus.
  static const OutlinedBorder mdShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusMd)),
  );

  /// Large rounded rectangle shape – cards, dialogs, sheets.
  static const OutlinedBorder lgShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusLg)),
  );

  /// Extra large rounded rectangle shape – bottom sheets.
  static const OutlinedBorder xlShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(radiusXl),
      topRight: Radius.circular(radiusXl),
    ),
  );

  /// Stadium (pill) shape for FABs, badges and tonal accents.
  static const OutlinedBorder fullShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(radiusFull)),
  );
}
