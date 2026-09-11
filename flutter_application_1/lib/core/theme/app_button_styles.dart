import 'package:flutter/material.dart';

import 'app_shapes.dart';

/// Material 3 button styles for the FundiLink design system.
///
/// Implements the six M3 common buttons – elevated, filled, filled tonal,
/// outlined, text and the icon-button family – plus segmented buttons.
/// Each style is derived from the active [ColorScheme] so light and dark
/// themes stay automatically consistent.
class AppButtonStyles {
  AppButtonStyles._();

  // Shared metrics from the M3 spec.
  static const double _height = 40.0;
  static const double _iconSize = 18.0;
  static const EdgeInsets _padding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 14);
  static const EdgeInsets _textPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
  static const Size _iconSizeSquare = Size.square(40);
  static const Size _iconSmallSize = Size.square(40);
  static const double _segmentedHeight = 40.0;

  // ---- Elevated button --------------------------------------------------

  /// Elevated button: primary container with a subtle lift when pressed.
  static ButtonStyle elevated(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onPrimary;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onPrimary, states),
        ),
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return 0.0;
          if (states.contains(WidgetState.pressed)) return 1.0;
          if (states.contains(WidgetState.hovered)) return 1.0;
          if (states.contains(WidgetState.focused)) return 0.0;
          return 0.0;
        }),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        minimumSize: const WidgetStatePropertyAll(Size(64, _height)),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_height)),
        padding: const WidgetStatePropertyAll(_padding),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  // ---- Filled button ----------------------------------------------------

  /// Filled button: highest emphasis without elevation, on neutral surfaces.
  static ButtonStyle filled(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onPrimary;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onPrimary, states),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        minimumSize: const WidgetStatePropertyAll(Size(64, _height)),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_height)),
        padding: const WidgetStatePropertyAll(_padding),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  // ---- Filled tonal button ----------------------------------------------

  /// Filled tonal button: secondary-container accent for paired actions.
  static ButtonStyle filledTonal(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return scheme.secondaryContainer;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onSecondaryContainer;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onSecondaryContainer, states),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        minimumSize: const WidgetStatePropertyAll(Size(64, _height)),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_height)),
        padding: const WidgetStatePropertyAll(_padding),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  // ---- Outlined button --------------------------------------------------

  /// Outlined button: medium emphasis for secondary actions.
  static ButtonStyle outlined(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return Colors.transparent;
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.primary, states),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(
              color: scheme.onSurface.withValues(alpha: 0.12),
            );
          }
          return BorderSide(color: scheme.outline);
        }),
        minimumSize: const WidgetStatePropertyAll(Size(64, _height)),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_height)),
        padding: const WidgetStatePropertyAll(_padding),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  // ---- Text button ------------------------------------------------------

  /// Text button: lowest emphasis for inline and tertiary actions.
  static ButtonStyle text(ColorScheme scheme) => ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.primary;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.primary, states),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        minimumSize: const WidgetStatePropertyAll(Size(64, _height)),
        fixedSize: const WidgetStatePropertyAll(Size.fromHeight(_height)),
        padding: const WidgetStatePropertyAll(_textPadding),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  // ---- Icon buttons -----------------------------------------------------

  /// Standard icon button: transparent surface, primary icon.
  static ButtonStyle iconStandard(ColorScheme scheme) => ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onSurfaceVariant, states),
        ),
        fixedSize: const WidgetStatePropertyAll(_iconSizeSquare),
        minimumSize: const WidgetStatePropertyAll(_iconSmallSize),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
      );

  /// Filled icon button: primary container with the strongest presence.
  static ButtonStyle iconFilled(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onPrimary;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onPrimary, states),
        ),
        fixedSize: const WidgetStatePropertyAll(_iconSizeSquare),
        minimumSize: const WidgetStatePropertyAll(_iconSmallSize),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
      );

  /// Tonal icon button: secondary-container background.
  static ButtonStyle iconTonal(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.12);
          }
          return scheme.secondaryContainer;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onSecondaryContainer;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onSecondaryContainer, states),
        ),
        fixedSize: const WidgetStatePropertyAll(_iconSizeSquare),
        minimumSize: const WidgetStatePropertyAll(_iconSmallSize),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
      );

  /// Outlined icon button: outline border with primary icon.
  static ButtonStyle iconOutlined(ColorScheme scheme) => ButtonStyle(
        backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          return scheme.onSurfaceVariant;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onSurfaceVariant, states),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: scheme.onSurface.withValues(alpha: 0.12));
          }
          return BorderSide(color: scheme.outline);
        }),
        fixedSize: const WidgetStatePropertyAll(_iconSizeSquare),
        minimumSize: const WidgetStatePropertyAll(_iconSmallSize),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: const WidgetStatePropertyAll(AppShapes.fullShape),
      );

  // ---- Segmented button -------------------------------------------------

  /// Segmented button: mutually-exclusive options with M3 spacing.
  static ButtonStyle segmented(ColorScheme scheme) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.secondaryContainer;
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withValues(alpha: 0.38);
          }
          if (states.contains(WidgetState.selected)) {
            return scheme.onSecondaryContainer;
          }
          return scheme.onSurface;
        }),
        overlayColor: WidgetStateProperty.resolveWith(
          (states) => _overlay(scheme.onSurface, states),
        ),
        elevation: const WidgetStatePropertyAll(0.0),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return BorderSide(color: scheme.onSurface.withValues(alpha: 0.12));
          }
          return BorderSide(color: scheme.outline);
        }),
        minimumSize: const WidgetStatePropertyAll(
          Size(64, _segmentedHeight),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
        iconSize: const WidgetStatePropertyAll(_iconSize),
        shape: WidgetStateProperty.resolveWith(
          (states) => _segmentedShape(scheme, states),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      );

  static OutlinedBorder _segmentedShape(
    ColorScheme scheme,
    Set<WidgetState> states,
  ) {
    final side = BorderSide(color: scheme.outline);
    return RoundedRectangleBorder(
      borderRadius: AppShapes.sm,
      side: side,
    );
  }

  // ---- Widget-level theme data -------------------------------------------

  /// Builds the elevated button theme.
  static ElevatedButtonThemeData elevatedTheme(ColorScheme scheme) =>
      ElevatedButtonThemeData(style: elevated(scheme));

  /// Builds the filled button theme.
  static FilledButtonThemeData filledTheme(ColorScheme scheme) =>
      FilledButtonThemeData(style: filled(scheme));

  /// Builds the outlined button theme.
  static OutlinedButtonThemeData outlinedTheme(ColorScheme scheme) =>
      OutlinedButtonThemeData(style: outlined(scheme));

  /// Builds the text button theme.
  static TextButtonThemeData textTheme(ColorScheme scheme) =>
      TextButtonThemeData(style: text(scheme));

  /// Builds the segmented button theme.
  static SegmentedButtonThemeData segmentedTheme(ColorScheme scheme) =>
      SegmentedButtonThemeData(style: segmented(scheme));

  /// Builds the icon button theme (standard).
  static IconButtonThemeData iconTheme(ColorScheme scheme) =>
      IconButtonThemeData(style: iconStandard(scheme));
}

/// Returns the pressed/hover/focused overlay color for [base].
Color? _overlay(Color base, Set<WidgetState> states) {
  if (states.contains(WidgetState.pressed)) {
    return base.withValues(alpha: 0.12);
  }
  if (states.contains(WidgetState.hovered)) {
    return base.withValues(alpha: 0.08);
  }
  if (states.contains(WidgetState.focused)) {
    return base.withValues(alpha: 0.10);
  }
  return null;
}
