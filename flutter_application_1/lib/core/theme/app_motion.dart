import 'package:flutter/animation.dart';

/// Material 3 motion tokens for the FundiLink design system.
///
/// M3 emphasizes purposeful, quick transitions: emphasized easing for
/// large transformative movement, standard easing for small changes.
class AppMotion {
  AppMotion._();

  /// Short duration – color, opacity and ripple changes.
  static const Duration short = Duration(milliseconds: 150);

  /// Medium duration – small layout and state changes.
  static const Duration medium = Duration(milliseconds: 250);

  /// Long duration – modals, sheets and screen transitions.
  static const Duration long = Duration(milliseconds: 300);

  /// Extra long duration – hero and full-screen shared-axis transitions.
  static const Duration extraLong = Duration(milliseconds: 450);

  /// Emphasized easing for large, transformative transitions.
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Standard easing for small component transitions.
  static const Curve standard = Curves.easeInOut;

  /// Decelerated easing for elements entering the screen.
  static const Curve decelerated = Curves.easeOutCubic;

  /// Accelerated easing for elements exiting the screen.
  static const Curve accelerated = Curves.easeInCubic;

  /// Standard spring for playful press feedback.
  static const Curve spring = Curves.easeOutBack;
}
