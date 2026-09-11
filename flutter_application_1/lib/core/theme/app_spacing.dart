/// Material 3 spacing tokens for the FundiLink design system.
///
/// Spacing follows the Material 3 layout baseline: a 4dp grid with fixed
/// increments for margins and gutters. Prefer these tokens over raw numbers
/// so vertical rhythm stays consistent across screens.
class AppSpacing {
  AppSpacing._();

  /// 4dp – hairline gaps, icon-to-label nudges.
  static const double xxs = 4.0;

  /// 8dp – compact gaps inside components.
  static const double xs = 8.0;

  /// 12dp – tight gutters between related items.
  static const double sm = 12.0;

  /// 16dp – default gutter between components.
  static const double md = 16.0;

  /// 20dp – comfortable gutter for medium-density layouts.
  static const double lg = 20.0;

  /// 24dp – section padding and expanded gutters.
  static const double xl = 24.0;

  /// 32dp – separation between content groups.
  static const double xxl = 32.0;

  /// 40dp – large section separation.
  static const double xxxl = 40.0;

  /// 48dp – screen-level padding for prominent sections.
  static const double huge = 48.0;

  /// 64dp – hero spacing for splash and empty states.
  static const double massive = 64.0;

  /// Minimum touch target size required by Material accessibility.
  static const double minTouchTarget = 48.0;

  /// Standard content gutter for edge-to-edge screens.
  static const double screenGutter = 16.0;

  /// Wider content gutter for tablet / landscape layouts.
  static const double screenGutterWide = 24.0;
}
